<?php
class Conclusions
{
  function checkOrRedirect($path_pieces)
  {
    return true;
  }
  function getHandle() { return "conclusions"; }
  function getTitle() { return "Project Conclusions"; }
  function outputSidebar()
  {
  }
  function outputBody()
  {
    echo "<div class=\"about\">\n";
    require (DOCUMENT_ROOT . "/documents/conclusions.txt");
    echo "</div>\n";
  }
}
?>
