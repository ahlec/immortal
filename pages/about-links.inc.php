<?php
class AboutLinks
{
  private $_personHandle;
  private $_personXML = null;
  private $_xsltProcessor = null;
  function checkOrRedirect($path_pieces)
  {
    return true;
  }
  function getHandle() { return "about"; }
  function getTitle() { return "Project Links"; }
  function outputSidebar()
  {
    About::outputSidebar("links");
  }
  function outputBody()
  {
    echo "<div class=\"about\">\n";
    require (DOCUMENT_ROOT . "/documents/about-links.txt");
    echo "</div>\n";
  }
}
?>
