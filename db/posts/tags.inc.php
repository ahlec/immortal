<?php
if (!defined("IS_SITE_PAGE"))
  exit("This may not be run from the browser.");
$tagsXML = new SimpleXMLElement("<tags></tags>");
$tags = array();
$posts = glob(DOCUMENT_ROOT . "/db/posts/*.xml");
if (in_array(DOCUMENT_ROOT . "/db/posts/tags.xml", $posts))
  unset($posts[array_search(DOCUMENT_ROOT . "/db/posts/tags.xml", $posts)]);
foreach ($posts as $post)
{
  $postXML = simplexml_load_file($post);
  $postTags = $postXML->xpath("//tag");
  foreach ($postTags as $postTag)
  {
    if (!in_array((string)$postTag, array_keys($tags)))
      $tags[(string)$postTag] = array();
    $tags[(string)$postTag][] = (string)$postXML->datetime;
  }
}
foreach ($tags as $tag => $postsWithTag)
{
  $tagElement = $tagsXML->addChild("tag");
  $tagElement->addChild("name", $tag);
  $postsWithTagElement = $tagElement->addChild("posts");
  foreach ($postsWithTag as $postWithTag)
    $postsWithTagElement->addChild("post", $postWithTag);
}
$tagsXML->asXML(DOCUMENT_ROOT . "/db/posts/tags.xml");
?>
