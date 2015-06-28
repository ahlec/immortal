<?php
class AboutHelp
{
  private $_personHandle;
  private $_personXML = null;
  private $_xsltProcessor = null;
  function checkOrRedirect($path_pieces)
  {
    return true;
  }
  function getHandle() { return "about"; }
  function getTitle() { return "Help"; }
  function outputSidebar()
  {
    About::outputSidebar("links");
  }
  function outputBody()
  {
    echo "<div class=\"about\">\n";
    require (DOCUMENT_ROOT . "/documents/about-help.txt");
    echo "</div>\n";
  }
}
?>
