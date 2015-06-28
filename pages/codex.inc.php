<?php
class Codex
{
  private $_codexHandle = null;
  private $_codexHandleType = null;

  private $_codexXML = null;
  private $_xsltProcessor = null;

  private $_navbarXML = null;
  private $_navbarXSLT = null;

  function checkOrRedirect($path_pieces)
  {
    $this->_codexXML = @simplexml_load_file(DOCUMENT_ROOT . "/documents/codexData.xml");
    $this->_navbarXML = $this->_codexXML;
    $xsltStylesheetName = "codexMain";

    if (isset($path_pieces[1]) && isset($path_pieces[2]))
    {
      $passed_handle = preg_replace("/[^a-z0-9]/", "", mb_strtolower($path_pieces[2]));
      if (mb_strtolower($path_pieces[1]) == "entry" && sizeof($this->_codexXML->xpath("//*[@lowerCaseHandle = '" .
	$passed_handle . "']")) > 0)
      {
        $entryXML = $this->_codexXML->xpath("//*[@lowerCaseHandle = '" . $passed_handle . "']");
        $this->_codexXML = $entryXML[0];
        $this->_codexHandle = $passed_handle;
        $this->_codexHandleType = $this->_codexXML->getName();//"character";
        $xsltStylesheetName = "codexCharacter";
     //   $characterXML = $this->_codexXML->xpath("//character[@lowerCaseHandle = '" . $passed_handle . "']");
     //   $this->_codexXML = $characterXML[0];
      } else if (mb_strtolower($path_pieces[1]) == "locations" && sizeof($this->_codexXML->xpath("//location[@lowerCaseHandle = '" .
	$passed_handle . "']")) > 0)
      {
        $this->_codexHandle = $passed_handle;
        $this->_codexHandleType = "location";
        $xsltStylesheetName = "codexCharacter";//"codexLocation";
        $locationXML = $this->_codexXML->xpath("//location[@lowerCaseHandle = '" . $passed_handle . "']");
        $this->_codexXML = $locationXML[0];
      } else if (mb_strtolower($path_pieces[1]) == "references" && sizeof($this->_codexXML->xpath("//reference[@lowerCaseHandle = '" .
	$passed_handle . "']")) > 0)
      {
        $this->_codexHandle = $passed_handle;
        $this->_codexHandleType = "reference";
        $xsltStylesheetName = "codexCharacter";//"codexReference";
        $referenceXML = $this->_codexXML->xpath("//reference[@lowerCaseHandle = '" . $passed_handle . "']");
        $this->_codexXML = $referenceXML[0];
      } else if (mb_strtolower($path_pieces[1]) == "spells" && sizeof($this->_codexXML->xpath("//spell[@lowerCaseHandle = '" .
	$passed_handle . "']")) > 0)
      {
	$this->_codexHandle = $passed_handle;
	$this->_codexHandleType = "spell";
	$xsltStylesheetName = "codexCharacter";
	//$xsltStylesheetName = "codexSpell";
	$spellXML = $this->_codexXML->xpath("//spell[@lowerCaseHandle = '" . $passed_handle . "']");
	$this->_codexXML = $spellXML[0];
      }
    }
    $codexStyleSheet = new DOMDocument();
    $codexStyleSheet->load(DOCUMENT_ROOT . "/documents/" . $xsltStylesheetName . ".xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->importStylesheet($codexStyleSheet);

    $navbarStylesheet = new DOMDocument();
    $navbarStylesheet->load(DOCUMENT_ROOT . "/documents/codexNav.xsl");
    $this->_navbarXSLT = new XSLTProcessor();
    $this->_navbarXSLT->setParameter('', 'urlPath', URL_PATH);
    $this->_navbarXSLT->setParameter('', 'currentHandle', $this->_codexHandle);
    $this->_navbarXSLT->setParameter('', 'currentHandleType', $this->_codexHandleType);
    $this->_navbarXSLT->importStylesheet($navbarStylesheet);

    return true;
  }
  function outputHEAD()
  {
    echo "<script>\n";
    echo " var openedNavSection = " . ($this->_codexHandleType == null ? "null" : "'" . $this->_codexHandleType . "'") . ";\n";
    echo "</script>\n";
  }
  function getHandle() { return "codex"; }
  function getTitle() { return "Codex Immortalus"; }
  function outputSidebar($subpage = null, $handle = null)
  {
    $navbarXMLDOM = new DOMDocument();
    $navbarXMLDOM->loadXML($this->_navbarXML->asXML());
    $this->_navbarXSLT->transformToURI($navbarXMLDOM, "php://output");
  }
  function outputBody()
  {
    $codexXMLDOM = new DOMDocument();
    $codexXMLDOM->loadXML($this->_codexXML->asXML());
    $this->_xsltProcessor->transformToURI($codexXMLDOM, "php://output");
  }
}
