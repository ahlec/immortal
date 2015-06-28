<?php
class PostComment
{
  private $_postTimestamp = null;
  private $_postXML = null;
  private $_commentTimestamp = null;
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

    if ((isset($_POST["postTimestamp"]) || $this->_postTimestamp != null) && isset($_POST["comment"]))
    {
print_r($_POST);
      if (file_exists(DOCUMENT_ROOT . "/db/posts/" . $_POST["postTimestamp"] . ".xml") )//&&
      {
        $body = html_entity_decode($_POST["comment"]);
        $postTimestamp = ($this->_postTimestamp != null ? $this->_postTimestamp : $_POST["postTimestamp"]);
        if ($this->_commentTimestamp != null)
        {
          $comment = $this->_postXML->xpath("//comment[@datetime ='" . $this->_commentTimestamp . "']/preceding-sibling::*");
          $commentPosition = sizeof($comment);
          $this->_postXML->comments->comment[$commentPosition] = $body;
          $post = $this->_postXML;
        } else
        {
          $post = simplexml_load_file(DOCUMENT_ROOT . "/db/posts/" . $postTimestamp . ".xml");
          if (!isset($post->comments))
            $post->addChild("comments");
          $comment = $post->comments[0]->addChild("comment", $body);
          $comment->addAttribute("handle", $_SESSION[USER_SESSION]);
          $comment->addAttribute("datetime", time());
        }
      $xmlDOM = new DOMDocument('1.0');
      $xmlDOM->preserveWhiteSpace = true;
      $xmlDOM->formatOutput = false;
      $xmlDOM->substituteEntities = false;
      $replace = array("/&lt;/" => "<", "/&gt;/" => ">");
      $xmlDOM->loadXML(preg_replace(array_keys($replace), $replace, $post->asXML()));
      if ($xmlDOM->save(DOCUMENT_ROOT . "/db/posts/" . $postTimestamp . ".xml"))
      {
        header("Location: " . URL_PATH . "/");
        exit();
      }
      } else if (isset($_POST["postTimestamp"]))
        exit ("The post that you tried to comment on does not exist.");
    }
    return true;
  }
  function getHandle() { return "post-comment"; }
  function getTitle() { return "Post Comment"; }
  function outputSidebar()
  {
  }
  function outputBody()
  {
    if ($this->_postTimestamp == null || $this->_commentTimestamp == null)
    {
      echo "You attempted to modify a comment that does not exist, or you tried to comment on a post that doesn't exist, or you didn't supply either parameters. <a href=\"" . URL_PATH . "/\">Return to the main page?</a>\n";
      return;
    }
    echo "<h1>Modify Comment</h1>\n";
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
    echo "<form method=\"POST\" action=\"" . URL_PATH . "/post-comment/" . $this->_postTimestamp . "/" . $this->_commentTimestamp . "/\">\n";
    echo "  <input type=\"hidden\" name=\"postTimestamp\" value=\"" . $this->_postTimestamp . "\" />\n";
    echo "  <input type=\"hidden\" name=\"commentTimestamp\" value=\"" . $this->_commentTimestamp . "\" />\n";
    echo "  <textarea name=\"comment\" style=\"width:100%;max-width:100%;height:150px;display:block;\">";
    echo htmlentities(preg_replace(array("/^<comment(.*?)>/", "/<\\/comment>$/"), array("", ""), (string)$commentXML[0]->asXML()));
    echo "</textarea>\n";
    echo "<div style=\"margin-left:30px;\">NOTE: a special element for website links exists here. To create a link to the about page, type " .
        "&lt;link page=\"about/\"&gt;CLICK HERE TO GO TO THE ABOUT PAGE&lt;/link&gt;, and the system will translate that to &lt;a href=\"" .
        URL_PATH . "/about/\"&lt;CLICK HERE TO GO TO THE ABOUT PAGE&lt;/a&gt;. This is the best syntax, in case the website URL should ever " .
        "change on us.</div>\n";
    echo "  <input type=\"submit\" value=\"Save\" />\n";
    echo "</form>\n";
  }
}
?>
