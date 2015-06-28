<?php
class PageNotFound 
{
  function checkOrRedirect($path_pieces) { return true; }
  function getHandle() { return "page-not-found"; } 
  function getTitle() { return "404 Error"; }
  function outputSidebar()
  {
  }
  function outputBody() { echo "page could not be found!"; }
}
?>
