<?php
class Statistics
{
  private $_sampleSVG = null;
  private $_xsltProcessor = null;
  private $_documentXML = null;

  function checkOrRedirect($path_pieces)
  {
    $this->_documentXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/immortal.xml");

    if (isset($path_pieces[1]))
    {
      switch (mb_strtolower($path_pieces[1]))
      {
        case "spelling-by-chapter": return new StatisticsSPChapter();
        case "spelling-by-sentence": return new StatisticsSPSentence();
	case "spelling-corrections": return new StatisticsSPCorrections();
        case "grammar-by-sentence": return new StatisticsGrammarSentence();
        case "grammar-by-chapter": return new StatisticsGrammarChapter();
        case "paradoxes": return new StatisticsParadoxes();
        case "attire": return new StatisticsAttireGraph();
      }
    }
    $xStyleSheet = new DOMDocument();
    $xStyleSheet->load(DOCUMENT_ROOT . "/documents/statsGeneral.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->importStylesheet($xStyleSheet);

    return true;
  }
  function getHandle() { return "stats"; }
  public static function getTitle($append = null) { return "Goffik Statistics" . ($append != null ? ", " . $append : ""); }
  public static function outputSidebar($subpage = null)
  {
    echo "<h1 class=\"first\">General</h1>\n";
    echo "<a class=\"statLink" . ($subpage == null ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/general/\">- General Totals</a>\n";
    echo "<a class=\"statLink" . ($subpage == "paradoxes" ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/paradoxes/\">- Paradoxes</a>\n";
    echo "<h1>Spelling Mistakes</h1>\n";
    echo "<a class=\"statLink" . ($subpage == "spelling-by-chapter" ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/spelling-by-chapter/\">- By Chapter</a>\n";
    echo "<a class=\"statLink" . ($subpage == "spelling-by-sentence" ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/spelling-by-sentence/\">- By Sentence</a>\n";
    echo "<h1>Grammar Mistakes</h1>\n";
    echo "<a class=\"statLink" . ($subpage == "grammar-by-chapter" ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/grammar-by-chapter/\">- By Chapter</a>\n";
    echo "<a class=\"statLink" . ($subpage == "grammar-by-sentence" ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/grammar-by-sentence/\">- By Sentence</a>\n";
    echo "<h1>Attire</h1>\n";
    echo "<a class=\"statLink" . ($subpage == "attire" ? " current" : "") . "\" href=\"" .
	URL_PATH . "/stats/attire/\">- Length by chapter</a>\n";
  }
  function outputBody()
  {
    $XMLDOM = new DOMDocument();
    $XMLDOM->loadXML($this->_documentXML->asXML());
    $this->_xsltProcessor->transformToURI($XMLDOM, "php://output");
    echo "usf.";
  }
}
?>
