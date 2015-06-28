<?php
class DeleteComment
{
  private $_postTimestamp = null;
  private $_commentTimestamp = null;
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
    if (isset($path_pieces[2]) && ctype_digit($path_pieces[2]) && sizeof($this->_postXML->xpath("//comment[@datetime ='" .
	$path_pieces[2] . "']")) > 0)
      $this->_commentTimestamp = $path_pieces[2];

    if (isset($_POST["cancel"]))
    {
      header("Location: " . URL_PATH . "/");
      exit();
    }
    if (isset($_POST["delete"]) && $this->_postTimestamp != null && $this->_commentTimestamp != null)
    {
      $comment = $this->_postXML->xpath("//comment[@datetime ='" . $this->_commentTimestamp . "']/preceding-sibling::*");
//print_r($comment);      
$commentPosition = sizeof($comment);
  //    echo "comment position: " . $commentPosition;
      unset($this->_postXML->comments->comment[$commentPosition]);
      $xmlDOM = new DOMDocument('1.0');
      $xmlDOM->preserveWhiteSpace = true;
      $xmlDOM->formatOutput = false;
      $xmlDOM->substituteEntities = false;
      $replace = array("/&lt;/" => "<", "/&gt;/" => ">");
      $xmlDOM->loadXML(preg_replace(array_keys($replace), $replace, $this->_postXML->asXML()));
      if ($xmlDOM->save(DOCUMENT_ROOT . "/db/posts/" . $this->_postTimestamp . ".xml"))
      {
        header("Location: " . URL_PATH . "/");
        exit();
      }
    }
    return true;
  }
  function getHandle() { return "delete-comment"; }
  function getTitle() { return "Delete Comment"; }
  function outputSidebar()
  {
  }
  function outputBody()
  {
    if ($this->_postTimestamp == null || $this->_commentTimestamp == null)
    {
      echo "This post and/or comment does not exist, or you did not supply a post and/or to delete. Please <a href=\"" . URL_PATH . "/\">return to the main page</a>.\n";
      return;
    }
    echo "<h1>Confirm Deletion</h1>\n";
    echo "Are you sure you wish to delete the <b>following comment</b>?\n";
    echo "<hr />\n";
    $postStylesheet = new DOMDocument();
    $postStylesheet->load(DOCUMENT_ROOT . "/db/posts/stylesheet.xsl");
    $postXSLT = new XSLTProcessor();
    $postXSLT->registerPHPFunctions();
    $postXSLT->setParameter('', 'urlPath', URL_PATH);
    $postXSLT->setParameter('', 'datetimeFormat', DATETIME_FORMAT);
    $postXSLT->setParameter('', 'userSessionHandle', "none");
    $postXSLT->importStylesheet($postStylesheet);
    $postXMLDOM = new DOMDocument();
    $commentXML = $this->_postXML->xpath("//comment[@datetime = '" . $this->_commentTimestamp . "']");
    $postXMLDOM->loadXML($commentXML[0]->asXML());
    $postXSLT->transformToURI($postXMLDOM, "php://output");
    echo "<hr />\n";

    echo "<form style=\"text-align:center;\" method=\"POST\" action=\"" . URL_PATH . "/delete-comment/" . $this->_postTimestamp .
	"/" . $this->_commentTimestamp . "/\">\n";
    echo "  <input type=\"submit\" value=\"Delete\" name=\"delete\" />\n";
    echo "  <input type=\"submit\" value=\"Cancel\" name=\"cancel\" />\n";
    echo "</form>\n";
  }
}
?>
