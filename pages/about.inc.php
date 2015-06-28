<?php
class About
{
  function checkOrRedirect($path_pieces)
  {
    if (isset($path_pieces[1]) && in_array(mb_strtolower($path_pieces[1]), array("jacob", "eric", "janis")))
      return new AboutPerson();
    else if (isset($path_pieces[1]) && mb_strtolower($path_pieces[1]) == "links")
      return new AboutLinks();
    else if (isset($path_pieces[1]) && mb_strtolower($path_pieces[1]) == "help")
      return new AboutHelp();
    return true;
  }
  function getHandle() { return "about"; }
  function getTitle() { return "About"; }
  public static function outputSidebar($user_handle = null)
  {
    echo "<h1 class=\"first\">Project Info</h1>\n";
    echo "<div class=\"bullet\"><a href=\"" . URL_PATH . "/about/\" class=\"" . ($user_handle == null ? "current" : "other") .
	"\">Project Proposal</a></div>\n";
    echo "<div class=\"bullet\"><a href=\"" . URL_PATH . "/about/links/\" class=\"" . ($user_handle == "links" ? "current" : "other") . 
	"\">Links</a></div>\n";
    echo "<div class=\"bullet\"><a href=\"" . URL_PATH . "/about/help/\" class=\"" . ($user_handle == "help" ? "current" : "other") .
	"\">Navigation Help</a></div>\n";
    echo "<h1>Members</h1>\n";
    $onUserPage = true;//($user_handle != null);
    $userXML = simplexml_load_file(DOCUMENT_ROOT . "/db/users.xml");
    foreach ($userXML->children() as $user)
    {
      echo "<a href=\"" . URL_PATH . "/about/" .
	(string)($user->handle) . "/\" class=\"aboutProfileLink\">" .
	"<img src=\"" . URL_PATH. (string)($user->image) .
	"\" border=\"0\"" . ($onUserPage ? " class=\"" . ($user_handle == (string)($user->handle) ?
	"current" : "other") . "\" " :"") . "/></a>\n";
    }
  }
  function outputBody()
  {
    echo "<div class=\"about\">\n";
    require (DOCUMENT_ROOT . "/documents/about.txt");
    echo "</div>\n";
  }
}
?>
