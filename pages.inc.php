<?php
if (!defined("IS_SITE_PAGE"))
  exit ("This page cannot be loaded except by the website code.");
require_once ("pages/index.inc.php");
require_once ("pages/page-not-found.inc.php");
require_once ("pages/about.inc.php");
require_once ("pages/read.inc.php");
require_once ("pages/about-person.inc.php");
require_once ("pages/write-post.inc.php");
require_once ("pages/download.inc.php");
require_once ("pages/page-forbidden.inc.php");
require_once ("pages/login.inc.php");
require_once ("pages/logout.inc.php");
require_once ("pages/post-comment.inc.php");
require_once ("pages/codex.inc.php");
require_once ("pages/stats.inc.php");
require_once ("pages/delete-post.inc.php");
require_once ("pages/delete-comment.inc.php");
require_once ("pages/stats-sp-chapter.inc.php");
require_once ("pages/stats-sp-sentence.inc.php");
require_once ("pages/stats-sp-corrections.inc.php");
require_once ("pages/stats-paradoxes.inc.php");
require_once ("pages/about-links.inc.php");
require_once ("pages/about-help.inc.php");
require_once ("pages/conclusions.inc.php");
require_once ("pages/stats-grammar-sentence.inc.php");
require_once ("pages/stats-grammar-story.inc.php");
require_once ("pages/stats-attire.inc.php");

$_PAGES = array("index" => "Index", "posts" => "Index", "PageNotFound" => "PageNotFound",
	"read" => "Read", "about" => "About", "write-post" => "WritePost",
	"download" => "Download", "forbidden" => "PageForbidden", "login" => "Login", "logout" => "Logout",
	"post-comment" => "PostComment", "codex" => "Codex", "stats" => "Statistics", "delete-post" => "DeletePost",
	"delete-comment" => "DeleteComment", "conclusions" => "Conclusions");
$_ERROR_PAGES = array(404 => "PageNotFound", 403 => "PageForbidden");
function parsePath($path, $page_definitions, $error_pages)
{
  $path_pieces = explode("/", $path);
  if (sizeof($path_pieces) == 0 || $path_pieces[0] == "")
    $path_pieces[0] = "index";
  else
    $path_pieces[0] = mb_strtolower($path_pieces[0]);
  if (!in_array($path_pieces[0], array_keys($page_definitions)))
    $path_pieces = array($error_pages[404], $path_pieces[0]);
  return $path_pieces;
}
function selectPage($path_pieces, $page_definitions)
{
  $selected_page = new $page_definitions[$path_pieces[0]]();
  $selected_page_final = $selected_page->checkOrRedirect($path_pieces);
  while ($selected_page_final !== true)
  {
    $selected_page = $selected_page_final;
    $selected_page_final = $selected_page->checkOrRedirect($path_pieces);
  }
  return $selected_page;
}
class NavigationItem
{
  private $_pageHandle;
  private $_text;
  function __construct($page_handle, $text)
  {
    $this->_pageHandle = $page_handle;
    $this->_text = $text;
  }
  function getPageHandle() { return $this->_pageHandle; }
  function getTitle() { return $this->_text; }
}
$navigation_items = array(
  new NavigationItem("index", "Home"),
  new NavigationItem("about", "About"),
  new NavigationItem("read", "Read"),
  new NavigationItem("codex", "Codex"),
  new NavigationItem("stats", "Statistics"),
  new NavigationItem("download", "Download"),
  new NavigationItem("conclusions", "Conclusions")
);
?>
