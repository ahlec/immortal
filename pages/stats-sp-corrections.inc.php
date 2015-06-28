<?php
class StatisticsSPCorrections
{
  private $_documentXML = null;
  private $_spellingTypeXML = null;
  private $_xsltProcessor = null;
  private $_sessionKey = null;

  function checkOrRedirect($path_pieces)
  {
    $this->_sessionKey = STATS_SETTINGS_SESSION_PREFIX . "spCorrections";
    if (!isset($_SESSION[$this->_sessionKey]))
      $_SESSION[$this->_sessionKey] = array("phonetic");

    $this->_documentXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/immortal.xml");
    $this->_spellingTypeXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/spellingTypes.xml");
    foreach ($this->_spellingTypeXML->xpath("//type") as $spType)
        if (isset($path_pieces[2]) && (strtolower($path_pieces[2]) == strtolower($spType) || strtolower($path_pieces[2]) ==
		strtolower(str_replace("?", "q", $spType))))
        {
          if (sizeof($_SESSION[$this->_sessionKey]) > 1 && in_array((string)$spType, $_SESSION[$this->_sessionKey]))
            unset($_SESSION[$this->_sessionKey][array_search((string)$spType, $_SESSION[$this->_sessionKey])]);
          else if (!in_array((string)$spType, $_SESSION[$this->_sessionKey]))
            $_SESSION[$this->_sessionKey][] = (string)$spType;
          header("Location: " . URL_PATH . "/stats/spelling-corrections/");
        }

    $correctionsStyleSheet = new DOMDocument();
    $correctionsStyleSheet->load(DOCUMENT_ROOT . "/documents/storySpCorrections.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->setParameter('', "spellingTypes", implode(" ", $_SESSION[$this->_sessionKey]));
    $this->_xsltProcessor->importStylesheet($correctionsStyleSheet);

    return true;
  }
  function getHandle() { return "stats"; }
  function getTitle() { return Statistics::getTitle("Spelling Mistake Corrections"); }
  function outputSidebar()
  {
    Statistics::outputSidebar("spelling-corrections");
  }
  function outputBody()
  {
    echo "<h1>Spelling Mistakes by Chapter</h1>";
    foreach($this->_spellingTypeXML->xpath("/spellingTypes/type") as $spType)
    {
      echo "<div class=\"statsSpGridOption\"" .
	(in_array((string)$spType, $_SESSION[$this->_sessionKey]) ?
	" style=\"color:black;background-color:" . $spType->attributes()->color . ";\"" : "") . 
	"\"><input type=\"checkbox\" id=\"chapter-sp-toggle-" .
	(string)$spType . "\"" . (in_array((string)$spType, $_SESSION[$this->_sessionKey]) ? " checked=\"checked\"" : "") .
	" onclick=\"window.location = '" . URL_PATH . "/stats/spelling-by-chapter/" . str_replace("?", "q", (string)$spType) .
	"/'\"/><label for=\"chapter-sp-toggle-" . (string)$spType . "\">" . ucfirst((string)$spType) . "</label></div>";
    }
    echo "<div style=\"clear:both;\"></div>\n";

    $spCorrectionsXMLDOM = new DOMDocument();
    $spCorrectionsXMLDOM->loadXML($this->_documentXML->asXML());
    $this->_xsltProcessor->transformToURI($spCorrectionsXMLDOM, "php://output");
  }
}
?>
