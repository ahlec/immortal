<?php
class PageForbidden
{
  function checkOrRedirect($path_pieces) { return true; }
  function getHandle() { return "page-forbidden"; } 
  function getTitle() { return "403 Error"; }
  function outputSidebar()
  {
  }
  function outputBody()
  {
    echo "<h1>Access Forbidden</h1>\n";
    echo "The page, directory, or file that you attempted to load or download is not open to the public. If you are a member of the project, " .
	"then you should attempt to login via the <a href=\"" . URL_PATH . "/login/\">login form</a>; if you are not a member of the project, " .
	"then your best bet would be to <a href=\"" . URL_PATH . "/\">return to the homepage</a> and pretend like none of this ever happened.";
  }
}
?>
