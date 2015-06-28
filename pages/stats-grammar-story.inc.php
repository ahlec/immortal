<?php
class StatisticsGrammarChapter
{
  private $_documentXML = null;
  private $_grammarTypeXML = null;
  private $_xsltProcessor = null;
  private $_sessionKey = null;

  function checkOrRedirect($path_pieces)
  {
    $this->_sessionKey = STATS_SETTINGS_SESSION_PREFIX . "grammarByChapter";
    if (!isset($_SESSION[$this->_sessionKey]))
      $_SESSION[$this->_sessionKey] = array();

    $this->_documentXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/immortal.xml");
    $this->_grammarTypeXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/grammarTypes.xml");
    $toggle_all = false;
    if (isset($path_pieces[2]) && $path_pieces[2] == "all")
    {
      $toggle_all = true;
      if (sizeof($_SESSION[$this->_sessionKey]) > 0)
      {
        $_SESSION[$this->_sessionKey] = array();
        header("Location: " . URL_PATH . "/stats/grammar-by-chapter/");
        exit();
      }
    }
    foreach ($this->_grammarTypeXML->xpath("//type") as $grammarType)
    {
        if ($toggle_all)
        {
          $_SESSION[$this->_sessionKey][] = (string)$grammarType;
          continue;
        }
        if (isset($path_pieces[2]) && (strtolower($path_pieces[2]) == strtolower($grammarType) || strtolower($path_pieces[2]) ==
		strtolower(str_replace("?", "q", (string)$grammarType))))
        {
          if (in_array((string)$grammarType, $_SESSION[$this->_sessionKey]))
	    unset($_SESSION[$this->_sessionKey][array_search((string)$grammarType, $_SESSION[$this->_sessionKey])]);
          else if (!in_array((string)$grammarType, $_SESSION[$this->_sessionKey]))
            $_SESSION[$this->_sessionKey][] = (string)$grammarType;
          header("Location: " . URL_PATH . "/stats/grammar-by-chapter/");
        }
    }
    if ($toggle_all)
    {
      header("Location: " . URL_PATH . "/stats/grammar-by-chapter/");
      exit();
    }

    $svgStyleSheet = new DOMDocument();
    $svgStyleSheet->load(DOCUMENT_ROOT . "/documents/storyGrammarGraph.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->setParameter('', "grammarTypes", implode(" ", $_SESSION[$this->_sessionKey]));
    $this->_xsltProcessor->setParameter('', "grammarTypeCount", sizeof($_SESSION[$this->_sessionKey]));
    $this->_xsltProcessor->importStylesheet($svgStyleSheet);

    return true;
  }
  function getHandle() { return "stats"; }
  function getTitle() { return Statistics::getTitle("Grammar Mistakes by Chapter"); }
  function outputSidebar()
  {
    Statistics::outputSidebar("grammar-by-chapter");
  }
  function outputBody()
  {
    echo "<h1>Grammar Mistakes by Chapter</h1>";
    foreach($this->_grammarTypeXML->xpath("/grammarTypes/type") as $grammarType)
    {
      echo "<div class=\"statsSpGridOption\"" .
	(in_array((string)$grammarType, $_SESSION[$this->_sessionKey]) ?
	" style=\"color:black;background-color:" . $grammarType->attributes()->color . ";\"" : "") . 
	"\"><input type=\"checkbox\" id=\"chapter-grammar-toggle-" .
	(string)$grammarType . "\"" . (in_array((string)$grammarType, $_SESSION[$this->_sessionKey]) ? " checked=\"checked\"" : "") .
	" onclick=\"window.location = '" . URL_PATH . "/stats/grammar-by-chapter/" . str_replace("?", "q", (string)$grammarType) .
	"/'\"/><label for=\"chapter-grammar-toggle-" . (string)$grammarType . "\">" . ucfirst((string)$grammarType) . "</label></div>";
    }
    echo "<button onclick=\"window.location = '" . URL_PATH . "/stats/grammar-by-chapter/all/';\">Toggle All</button>\n";
    echo "<div style=\"clear:both;\"></div>\n";

    $svgXMLDOM = new DOMDocument();
    $svgXMLDOM->loadXML($this->_documentXML->asXML());
    $this->_xsltProcessor->transformToURI($svgXMLDOM, "php://output");
  }
}
?>
