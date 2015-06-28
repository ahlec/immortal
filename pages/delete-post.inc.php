<?php
class DeletePost
{
  private $_postTimestamp = null;
  private $_postXML = null;
  function checkOrRedirect($path_pieces)
  {
    if (!isset($_SESSION[USER_SESSION]))
      return new PageForbidden();
    if (isset($path_pieces[1]) && ctype_digit($path_pieces[1]) && file_exists(DOCUMENT_ROOT . "/db/posts/" . $path_pieces[1] . ".xml"))
    {
      $this->_postTimestamp = $path_pieces[1];
      $this->_postXML = simplexml_load_file(DOCUMENT_ROOT . "/db/posts/" . $this->_postTimestamp . ".xml",
	"SimpleXMLElement", LIBXML_NOENT);
    }
    if (isset($_POST["cancel"]))
    {
      header("Location: " . URL_PATH . "/");
      exit();
    }
    if (isset($_POST["delete"]) && $this->_postTimestamp != null)
    {
      unlink (DOCUMENT_ROOT . "/db/posts/" . $this->_postTimestamp . ".xml");
      require_once (DOCUMENT_ROOT . "/db/posts/tags.inc.php");
      header("Location: " . URL_PATH . "/");
      exit();
    }
    return true;
  }
  function getHandle() { return "delete-post"; }
  function getTitle() { return "Delete Post"; }
  function outputSidebar()
  {
  }
  function outputBody()
  {
    if ($this->_postTimestamp == null)
    {
      echo "This post does not exist, or you did not supply a post to delete. Please <a href=\"" . URL_PATH . "/\">return to the main page</a>.\n";
      return;
    }
    echo "<h1>Confirm Deletion</h1>\n";
    echo "Are you sure you wish to delete the <b>following post and all comments</b>?\n";
    echo "<hr />\n";
    $postStylesheet = new DOMDocument();
    $postStylesheet->load(DOCUMENT_ROOT . "/db/posts/stylesheet.xsl");
    $postXSLT = new XSLTProcessor();
    $postXSLT->registerPHPFunctions();
    $postXSLT->setParameter('', 'urlPath', URL_PATH);
    $postXSLT->setParameter('', 'datetimeFormat', DATETIME_FORMAT);
    $postXSLT->setParameter('', 'userSessionHandle', "none");
    $postXSLT->setParameter('', 'selectedTag', null);
    $postXSLT->importStylesheet($postStylesheet);
    $postXMLDOM = new DOMDocument();
    $postXMLDOM->loadXML($this->_postXML->asXML());
    $postXSLT->transformToURI($postXMLDOM, "php://output");
    echo "<hr />\n";

    echo "<form style=\"text-align:center;\" method=\"POST\" action=\"" . URL_PATH . "/delete-post/" . $this->_postTimestamp . "/\">\n";
    echo "  <input type=\"submit\" value=\"Delete\" name=\"delete\" />\n";
    echo "  <input type=\"submit\" value=\"Cancel\" name=\"cancel\" />\n";
    echo "</form>\n";
  }
}
?>
