<?php
class Index
{
  private $_pageNumber;
  private $_postFiles;
  private $_postXSLT;
  private $_totalPages;
  private $_tags = array();
  private $_currentTag = null;
  function checkOrRedirect($path_pieces)
  {
    if (isset($path_pieces[1]) && mb_strtolower($path_pieces[1]) == 'tagged')
    {
      $this->_currentTag = $path_pieces[2];
      if (isset($path_pieces[3]) && ctype_digit(str_replace("page-", "", mb_strtolower($path_pieces[3]))))
        $this->_pageNumber = abs(str_replace("page-", "", mb_strtolower($path_pieces[3])));
    }
    else if (isset($path_pieces[1]) && ctype_digit(str_replace("page-", "", mb_strtolower($path_pieces[1]))))
      $this->_pageNumber = abs(str_replace("page-", "", mb_strtolower($path_pieces[1])));
    else
      $this->_pageNumber = 1;
    if ($this->_pageNumber < 1)
      $this->_pageNumber = 1;
    $this->_postFiles = array();
    if ($this->_currentTag == null)
      $posts = glob(DOCUMENT_ROOT . "/db/posts/*.xml");
    else
    {
      $tagsXML = simplexml_load_file(DOCUMENT_ROOT . "/db/posts/tags.xml");
      $tagEntry = $tagsXML->xpath("/tags/tag[translate(name, ' ', '-') = '" . $this->_currentTag . "']");
      $posts = array();
      if (sizeof($tagEntry) > 0)
      {
        foreach ($tagEntry[0]->xpath(".//post") as $post)
          $posts[] = DOCUMENT_ROOT . "/db/posts/" . (string)$post . ".xml";
      }
      $this->_currentTag = preg_replace("/[[:space:]]/", "-", $this->_currentTag);
    }
    if (in_array(DOCUMENT_ROOT . "/db/posts/tags.xml", $posts))
      unset($posts[array_search(DOCUMENT_ROOT . "/db/posts/tags.xml", $posts)]);
    $this->_totalPages = ceil(sizeof($posts) / POSTS_PER_PAGE);
    if ($this->_totalPages == 0)
      $this->_totalPages = 1;
    if ($this->_pageNumber > $this->_totalPages)
      $this->_pageNumber = $this->_totalPages;
    rsort($posts, SORT_STRING);
    for ($index = ($this->_pageNumber - 1) * POSTS_PER_PAGE; $index < (sizeof($posts) - ($this->_pageNumber - 1) * POSTS_PER_PAGE < POSTS_PER_PAGE ? sizeof($posts) : $this->_pageNumber * POSTS_PER_PAGE); $index++)
	$this->_postFiles[] = $posts[$index];
    
    $tagsXML = simplexml_load_file(DOCUMENT_ROOT . "/db/posts/tags.xml");
    $tags = $tagsXML->xpath("//tag");
    foreach ($tags as $tag)
      $this->_tags[preg_replace("/[[:space:]]/", "-", (string)$tag->name)] = sizeof($tag->xpath(".//post"));
    arsort($this->_tags);
 
    $postStylesheet = new DOMDocument();
    $postStylesheet->load(DOCUMENT_ROOT . "/db/posts/stylesheet.xsl");
    $this->_postXSLT = new XSLTProcessor();
    $this->_postXSLT->registerPHPFunctions();
    $this->_postXSLT->setParameter('', 'urlPath', URL_PATH);
    $this->_postXSLT->setParameter('', 'datetimeFormat', DATETIME_FORMAT);
    $this->_postXSLT->setParameter('', 'userSessionHandle', isset($_SESSION[USER_SESSION]) ? $_SESSION[USER_SESSION] : "none");
    $this->_postXSLT->setParameter('', 'selectedTag', $this->_currentTag);
    $this->_postXSLT->importStylesheet($postStylesheet);
    return true;
  }
  function getHandle() { return "index"; }
  function getTitle() { return null; }
  function outputSidebar()
  {
    if (isset($_SESSION[USER_SESSION]))
      echo "<a href=\"" . URL_PATH . "/write-post/\" class=\"postWritePostButton\">New Post</a>\n";
    echo "<h1" . (isset($_SESSION[USER_SESSION]) ? "" : " class=\"first\"") . ">Tags</h1>\n";
    foreach ($this->_tags as $tag => $count)
      echo "<a class=\"navigationPostTag" . ($this->_currentTag == $tag ? " selectedTag" : "") . "\" href=\"" . URL_PATH . ($this->_currentTag == $tag ? "" : "/posts/tagged/" . $tag) . "/\">#" . $tag . " (" . $count . ")</a>\n";
  }
  function outputBody()
  {
    echo "<div class=\"postNavigation\">\n";
    echo ($this->_pageNumber > 1 ? "<a class=\"previous\" href=\"" . URL_PATH . "/" . ($this->_pageNumber - 1 > 1 ? "posts/" . ($this->_currentTag != null ? "tagged/" . $this->_currentTag . "/" : "") . "page-" . ($this->_pageNumber - 1) . "/" : ($this->_currentTag != null ? "posts/tagged/" . $this->_currentTag . "/" : "")) .
	"\">" : "<div class=\"previous\">") . "&larr; Previous Page" . ($this->_pageNumber > 1 ? "</a>" : "</div>") . "\n";
    echo ($this->_pageNumber < $this->_totalPages ? "<a class=\"next\" href=\"" . URL_PATH . "/posts/" . ($this->_currentTag != null ? "tagged/" . $this->_currentTag . "/" : "") . "page-" . ($this->_pageNumber + 1) . "/\">" : "<div class=\"next\">") .
        "Next Page &rarr;" . ($this->_pageNumber < $this->_totalPages ? "</a>" : "</div>") . "\n";
    echo "<strong>Page " . $this->_pageNumber . " of " . $this->_totalPages . "</strong>\n";
    echo "<div style=\"clear:both;\"></div>\n";
    echo "</div>\n";

    foreach ($this->_postFiles as $post)
    {
      $postXMLDOM = new DOMDocument();
      $postXMLDOM->load($post);
      $this->_postXSLT->transformToURI($postXMLDOM, "php://output");
    }

    echo "<div class=\"postNavigation\">\n";
    echo ($this->_pageNumber > 1 ? "<a class=\"previous\" href=\"" . URL_PATH . "/" . ($this->_pageNumber - 1 > 1 ? "posts/" . ($this->_currentTag != null ? "tagged/" . $this->_currentTag . "/" : "") . "page-" . ($this->_pageNumber - 1) . "/" : ($this->_currentTag != null ? "posts/tagged/" . $this->_currentTag . "/" : "")) .
        "\">" : "<div class=\"previous\">") . "&larr; Previous Page" . ($this->_pageNumber > 1 ? "</a>" : "</div>") . "\n";
    echo ($this->_pageNumber < $this->_totalPages ? "<a class=\"next\" href=\"" . URL_PATH . "/posts/" . ($this->_currentTag != null ? "tagged/" . $this->_currentTag . "/" : "") . "page-" . ($this->_pageNumber + 1) . "/\">" : "<div class=\"next\">") .
        "Next Page &rarr;" . ($this->_pageNumber < $this->_totalPages ? "</a>" : "</div>") . "\n";
    echo "<strong>Page " . $this->_pageNumber . " of " . $this->_totalPages . "</strong>\n";
    echo "<div style=\"clear:both;\"></div>\n";
    echo "</div>\n";

  }
}
?>
