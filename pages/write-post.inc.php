<?php
class WritePost
{
  private $_postFailed = false;
  private $_postFailedReason = null;
  private $_title = null;
  private $_body = null;
  private $_tags = null;
  private $_allTags = array();
  private $_modifyingPost = false;
  private $_modifyingPostTimestamp = null;
  private $_modifyingPostXML = null;
  function checkOrRedirect($path_pieces)
  {
    if (!isset($_SESSION[USER_SESSION]))
      return new PageForbidden();
    if (isset($path_pieces[1]) && ctype_digit($path_pieces[1]) && file_exists(DOCUMENT_ROOT . "/db/posts/" . $path_pieces[1] . ".xml"))
    {
      $this->_modifyingPost = true;
      $this->_modifyingPostTimestamp = $path_pieces[1];
      $this->_modifyingPostXML = simplexml_load_file(DOCUMENT_ROOT . "/db/posts/" . $this->_modifyingPostTimestamp . ".xml",
	"SimpleXMLElement", LIBXML_NOENT);
    }
    if (isset($_POST["body"]))
    {
      $title = $_POST["title"];
      $body = html_entity_decode($_POST["body"]);
      $body = preg_replace("/\r/","<br/>", $body);
      $tags = explode(",", $_POST["tags"]);
      if ($this->_modifyingPost)
      {
        $this->_modifyingPostXML->title[0] = $title;
        $this->_modifyingPostXML->body[0] = $body;
        $this->_modifyingPostXML->tags[0] = "";
        foreach ($tags as $tag)
          $this->_modifyingPostXML->tags[0]->addChild("tag", trim($tag));
        $post = $this->_modifyingPostXML;
        //$post = $this->_modifyingPostXML->asXML(DOCUMENT_ROOT . "/db/posts/" . $this->_modifyingPostTimestamp . ".xml");
      } else
      {
$postTime = time();
        $post = new SimpleXMLElement("<post></post>", LIBXML_NOENT);
        $post->addChild("user", $_SESSION[USER_SESSION]);
        $post->addChild("title", $title);
        $post->addChild("datetime", $postTime);
        $post->addChild("body", $body);
        $tagsElement = $post->addChild("tags");
        foreach ($tags as $tag)
          $tagsElement->addChild("tag", trim($tag));
        $post->addChild("comments");
        //$posted = $post->asXML(DOCUMENT_ROOT . "/db/posts/" . time() . ".xml");
      }
      $xmlDOM = new DOMDocument('1.0');
      $xmlDOM->preserveWhiteSpace = true;
      $xmlDOM->formatOutput = false;
      $xmlDOM->substituteEntities = false;
      $replace = array("/&lt;/" => "<", "/&gt;/" => ">");
$xmlInput = htmlspecialchars_decode($post->asXML());
 //     $xmlInput = preg_replace(array_keys($replace), $replace, $post->asXML());
//echo $xmlInput;
      if (!@$xmlDOM->loadXML($xmlInput))
      {
        $this->_postFailed = true;
        $this->_postFailedReason = "Malformed XML";
        $this->_title = $title;
        $this->_body = $body;
        $this->_tags = implode(",", $tags);
      } else
      {
      $xmlDOM->loadXML($xmlInput);
//      echo $xmlDOM->saveXML();
//exit();
      if ($xmlDOM->save(DOCUMENT_ROOT . "/db/posts/" . ($this->_modifyingPost ? $this->_modifyingPostTimestamp : $postTime) . ".xml"))
      {
        require_once (DOCUMENT_ROOT . "/db/posts/tags.inc.php");
        header("Location: " . URL_PATH . "/");
        exit(); 
      }
      }
    }

    $tagsXML = simplexml_load_file(DOCUMENT_ROOT . "/db/posts/tags.xml");
    $allTags = $tagsXML->xpath("//tag");
    foreach ($allTags as $tag)
      $this->_allTags[preg_replace("/[[:space:]]/", "-", (string)$tag->name)] = sizeof($tag->xpath(".//post"));
    arsort($this->_allTags);

    return true;
  }
  function getHandle() { return "write-post"; }
  function getTitle() { return "Write Post"; }
  function outputSidebar()
  {
    echo "<h1 class=\"first\">Tags Being Used</h1>\n";
    foreach ($this->_allTags as $tag => $count)
      echo "<div style=\"margin-left:5px;\">&rsaquo; " . $tag . " (" . $count . ")</div>\n";
  }
  function outputBody()
  {
    if ($this->_postFailed)
      echo "<div style=\"background-color:red;text-align:center;margin-bottom:5px;\"><b>Posting Failed:</b> " . $this->_postFailedReason . "</div>\n";
    echo "<form method=\"POST\" action=\"" . URL_PATH . "/write-post/" . ($this->_modifyingPost ? $this->_modifyingPostTimestamp . "/" : "") .
	"\">\n";
    $user_db = simplexml_load_file(DOCUMENT_ROOT . "/db/users.xml");
    $user = $user_db->xpath("//user[handle/text() = '" . ($this->_modifyingPost ? (string)$this->_modifyingPostXML->user[0] : 
	$_SESSION[USER_SESSION]) . "']");
    echo "<b>User:</b> " . (string)$user[0]->firstName . " " . (string)$user[0]->lastName . "</select><br />\n";
    echo "<b>Title:</b> <input style=\"width:100%;display:block;\" type=\"text\" name=\"title\" " . ($this->_postFailed ? "value=\"" .
	addslashes($this->_title) . "\"" : ($this->_modifyingPost ? "value=\"" .
	addslashes((string)$this->_modifyingPostXML->title) . "\" " : "")) . "/><br />\n";
    echo "<b>Post:</b> <textarea style=\"max-width:100%;display:block;height:200px;width:100%;\" name=\"body\">" . htmlspecialchars(($this->_postFailed ? 
	$this->_body : ($this->_modifyingPost ? preg_replace(array("/^<body>/", "/<\\/body>$/"), array("", ""), (string)$this->_modifyingPostXML->body[0]->asXML()) : ""))) . "</textarea>\n";
    echo "<ul>\n";
    echo "<li><b style=\"color:#440000;\">LINKS:</b> a special element for website links exists here. To create a link to the about page, type " .
	"&lt;link page=\"about/\"&gt;CLICK HERE TO GO TO THE ABOUT PAGE&lt;/link&gt;, and the system will translate that to &lt;a href=\"" .
	URL_PATH . "/about/\"&lt;CLICK HERE TO GO TO THE ABOUT PAGE&lt;/a&gt;. This is the best syntax, in case the website URL should ever " .
	"change on us.</li>\n";
    echo "<li><b style=\"color:#440000;\">XML:</b> XML is supported, but in order to output properly, <b>needs</b> to be within the &lt;code&gt; element.</li>\n";
    echo "</ul>\n";
    echo "<b>Tags:</b> <small>(comma delineated)</small> <textarea style=\"max-width:100%;display:block;height:100px;width:100%;\" name=\"tags\">";
    if ($this->_postFailed)
      echo $this->_tags;
    else if ($this->_modifyingPost)
    {
      $index = 0;
      foreach ($this->_modifyingPostXML->tags->tag as $tag)
      {
        echo ($index > 0 ? ", " : "") . (string)$tag;
        $index++;
      }
    }
    echo "</textarea>\n";
    echo "<input type=\"submit\" value=\"Post\" />\n";
    echo "</form>\n";
  }
}
?>
