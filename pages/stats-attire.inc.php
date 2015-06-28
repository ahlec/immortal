<?php
class StatisticsAttireGraph
{
  private $_documentXML = null;
  private $_xsltProcessor = null;

  function checkOrRedirect($path_pieces)
  {
    $this->_documentXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/immortal.xml");

    $svgStyleSheet = new DOMDocument();
    $svgStyleSheet->load(DOCUMENT_ROOT . "/documents/attireGraph.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->importStylesheet($svgStyleSheet);

    return true;
  }
  function getHandle() { return "stats"; }
  function getTitle() { return Statistics::getTitle("Attire length by Chapter"); }
  function outputSidebar()
  {
    Statistics::outputSidebar("attire");
  }
  function outputBody()
  {
    echo "<h1>Attire length by Chapter</h1>";

    $svgXMLDOM = new DOMDocument();
    $svgXMLDOM->loadXML($this->_documentXML->asXML());
    $this->_xsltProcessor->transformToURI($svgXMLDOM, "php://output");
  }
}
?>
