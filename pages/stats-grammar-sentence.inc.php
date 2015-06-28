<?php
class StatisticsGrammarSentence
{
  private $_documentXML = null;
  private $_grammarTypeXML = null;
  private $_numberChapters = null;
  private $_sessionKey;

  function checkOrRedirect($path_pieces)
  {
    $this->_sessionKey = STATS_SETTINGS_SESSION_PREFIX . "grammarBySentence";
    if (!isset($_SESSION[$this->_sessionKey]))
      $_SESSION[$this->_sessionKey] = array("chapter" => 1, "types" => array());

    $this->_documentXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/immortal.xml");
    $this->_grammarTypeXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/grammarTypes.xml");
    $toggle_all = false;
    if (isset($path_pieces[2]) && $path_pieces[2] == "all")
    {
      $toggle_all = true;
      if (sizeof($_SESSION[$this->_sessionKey]["types"]) > 0)
      {
        $_SESSION[$this->_sessionKey]["types"] = array();
        header("Location: " . URL_PATH . "/stats/grammar-by-sentence/");
        exit();
      }
    }
    foreach ($this->_grammarTypeXML->xpath("//type") as $grammarType)
    {
        if ($toggle_all)
        {
          $_SESSION[$this->_sessionKey]["types"][] = (string)$grammarType;
          continue;
        }
        if (isset($path_pieces[2]) && (strtolower($path_pieces[2]) == strtolower($grammarType) || strtolower($path_pieces[2]) ==
                strtolower(str_replace("?", "q", $grammarType))))
        {
          if (in_array((string)$grammarType, $_SESSION[$this->_sessionKey]["types"]))
            unset($_SESSION[$this->_sessionKey]["types"][array_search((string)$grammarType, $_SESSION[$this->_sessionKey]["types"])]);
          else if (!in_array((string)$grammarType, $_SESSION[$this->_sessionKey]["types"]))
            $_SESSION[$this->_sessionKey]["types"][] = (string)$grammarType;
          header("Location: " . URL_PATH . "/stats/grammar-by-sentence/");
          exit();
        }
    }
    if ($toggle_all)
    {
      header("Location: " . URL_PATH . "/stats/grammar-by-sentence/");
      exit();
    }
    $this->_numberChapters = sizeof($this->_documentXML->story[0]->chapter);
    if (isset($path_pieces[2]) && strtolower($path_pieces[2]) == "change-chapter" && isset($path_pieces[3]) && ctype_digit($path_pieces[3]) &&
	$path_pieces[3] > 0 && $path_pieces[3] <= $this->_numberChapters)
    {
      $_SESSION[$this->_sessionKey]["chapter"] = $path_pieces[3];
      header("Location: " . URL_PATH . "/stats/grammar-by-sentence/");
      exit();
    }

    $svgStyleSheet = new DOMDocument();
    $svgStyleSheet->load(DOCUMENT_ROOT . "/documents/grammarTypeSentences.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->setParameter('', "chapterNum", $_SESSION[$this->_sessionKey]["chapter"]);
    $this->_xsltProcessor->setParameter('', "grammarTypes", implode(" ", $_SESSION[$this->_sessionKey]["types"]));
    $this->_xsltProcessor->importStylesheet($svgStyleSheet);
    return true;
  }
  function getHandle() { return "stats"; }
  function getTitle() { return Statistics::getTitle("Grammar Mistakes by Sentence"); }
  public static function outputSidebar()
  {
    Statistics::outputSidebar("grammar-by-sentence");
  }
  function outputBody()
  {
    echo "<h1>Grammar Mistakes By Sentence</h1>\n";
    echo "<p>This interactive chart tracks the number of grammar mistakes by sentence of a selected chapter. Use the checkboxes to select the desired types and the drop down menu to select the chapter.</p>";
    echo "<select onchange=\"window.location = '" . URL_PATH . "/stats/grammar-by-sentence/change-chapter/' + " .
	"this.options[this.selectedIndex].value;\" class=\"chapterSelectBox\">\n";
    for ($chapterNumber = 1; $chapterNumber <= $this->_numberChapters; $chapterNumber++)
      echo "  <option value=\"" . $chapterNumber . "\"" . ($chapterNumber == $_SESSION[$this->_sessionKey]["chapter"] ?
	" selected=\"selected\"" : "") . ">Chapter " . $chapterNumber . "</option>\n";
    echo "</select>\n";
    foreach($this->_grammarTypeXML->xpath("/grammarTypes/type") as $grammarType)
      echo "<div class=\"statsSpGridOption\"" .
	(in_array((string)$grammarType, $_SESSION[$this->_sessionKey]["types"]) ?
	" style=\"color:black;background-color:" . $grammarType->attributes()->color . ";\"" : "") .
        "\"><input type=\"checkbox\" id=\"sentence-grammar-toggle-" .
        (string)$grammarType . "\"" . (in_array((string)$grammarType, $_SESSION[$this->_sessionKey]["types"]) ? " checked=\"checked\"" : "") .
        " onclick=\"window.location = '" . URL_PATH . "/stats/grammar-by-sentence/" . str_replace("?", "q", (string)$grammarType) .
        "/'\"/><label for=\"sentence-grammar-toggle-" . (string)$grammarType . "\">" . ucfirst((string)$grammarType) . "</label></div>";
    echo "<button onclick=\"window.location = '" . URL_PATH . "/stats/grammar-by-sentence/all/';\">Toggle All</button>\n";
    echo "<div style=\"clear:both;\"></div>\n";

    $svgXMLDOM = new DOMDocument();
    $svgXMLDOM->loadXML($this->_documentXML->asXML());
    $this->_xsltProcessor->transformToURI($svgXMLDOM, "php://output");

  }
}
?>
