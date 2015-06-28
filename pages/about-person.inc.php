<?php
class AboutPerson
{
  private $_personHandle;
  private $_personXML = null;
  private $_xsltProcessor = null;
  function checkOrRedirect($path_pieces)
  {
    // We've ONLY gotten here by checking in About. We could check here, but with constraints already...
    $this->_personHandle = mb_strtolower($path_pieces[1]);
    $usersXML = @simplexml_load_file(DOCUMENT_ROOT . "/db/users.xml");
    $personXML = $usersXML->xpath("//user[handle = '" . $this->_personHandle . "']");
    $this->_personXML = $personXML[0];
    $aboutStyleSheet = new DOMDocument();
    $aboutStyleSheet->load(DOCUMENT_ROOT . "/documents/userProfile.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->importStylesheet($aboutStyleSheet);
    return true;
  }
  function getHandle() { return "about"; }
  function getTitle() { return "About"; }
  function outputSidebar()
  {
    About::outputSidebar($this->_personHandle);
  }
  function outputBody()
  {
    $personXMLDOM = new DOMDocument();
    $personXMLDOM->loadXML($this->_personXML->asXML());
    $this->_xsltProcessor->transformToURI($personXMLDOM, "php://output");
  }
}
?>
