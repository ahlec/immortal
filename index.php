<?php
define ("IS_SITE_PAGE", true);
@session_start();
require_once ("config.inc.php");
require_once ("pages.inc.php");
$path = (isset($_GET["path"]) ? $_GET["path"] : "index");
$path_pieces = parsePath($path, $_PAGES, $_ERROR_PAGES);
$page = selectPage($path_pieces, $_PAGES);
try
{
  $immortal_document = simplexml_load_file(DOCUMENT_ROOT . "/documents/character-dialogue.xml");
  $feature_quote = $immortal_document->dialogue[mt_rand(0, sizeof($immortal_document->dialogue))];
  if (!is_object($feature_quote))
   throw new Exception("derped");
  $character_profile = $immortal_document->xpath("//character[./@handle = '" . $feature_quote->attributes()->handle . "']");
} catch (Exception $exception)
{
  header("Location: http://" . $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"]); 
  exit();
}
echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" " .
	"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n";
echo "<html>\n";
echo "  <head>\n";
echo "    <title>My Immortal" . ($page->getTitle() !== null ? " - " .
	$page->getTitle() : "") . "</title>\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/stylesheet.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/posts.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/about.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/read.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/dialog.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/downloads.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/codex.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/stats.css\" />\n";
echo "    <link rel=\"stylesheet\" href=\"" . URL_PATH . "/addon-styles/collapse.css\" />\n";
echo "    <script>
   var URL_PATH = '" . URL_PATH . "';
   var codexHandles = new Array(";
$codexData = @simplexml_load_file(DOCUMENT_ROOT . "/documents/codexData.xml");
$codexEntries = $codexData->xpath("/codexData/characterList/character|/codexData/referenceList/reference|/codexData/locationList/location|/codexData/spellList/spell|/codexData/chapters/chapter");
foreach ($codexEntries as $index => $codexEntry)
  echo "'" . $codexEntry->attributes()->handle . "','" .
	preg_replace("/\'/", "&apos;", (string)$codexEntry->name) .
	"'" . ($index < sizeof($codexEntries) - 1 ?"," : "");
echo ");
   function translateHandleToText(handle)
   {
     for (var index = 0; index < codexHandles.length; index += 2)
       if (codexHandles[index] == handle)
         return codexHandles[index + 1];
     return null;
   }
</script>\n";
echo "    <script src=\"" . URL_PATH . "/addon-styles/jsAjax.js\"></script>\n";
echo "    <script src=\"" . URL_PATH . "/addon-styles/jsCodex.js\"></script>\n";
echo "    <script src=\"" . URL_PATH . "/addon-styles/jsPopup.js\"></script>\n";
//echo "    <script src=\"" . URL_PATH . "/addon-styles/jsSidebar.js\"></script>\n";
echo "    <script src=\"" . URL_PATH . "/addon-styles/jwplayer.js\"></script>\n";
if (method_exists($page, "outputHEAD"))
  $page->outputHEAD();
echo "  </head>\n";
echo "  <body" . (method_exists($page, "getBODYAppend") && $page->getBODYAppend() != null ? " " . $page->getBODYAppend() : "") . ">\n";
echo "    <div class=\"obdurodonLink\"><a href=\"http://www.obdurodon.org/\" target=\"_blank\">&lt;oo&gt;</a> &rarr; <a href=\"http://dh.obdurodon.org/\" target=\"_blank\">&lt;dh&gt;</a> &rarr; " . ($page->getHandle() == "index" ? "<span>" : "<a href=\"" . URL_PATH . "/\">") .
	"&lt;" . OBDURODON_ABBREVIATION . "&gt;" . ($page->getHandle() == "index" ? "</span>" : "</a>") . " \"My Immortal\"</div>\n";
echo "    <div class=\"container\">\n";
echo "      <a name=\"top\"/>\n";
echo "      <div class=\"header\"><div class=\"wrapping\">\n";
echo "        <a href=\"" . URL_PATH . "/\"><img class=\"characterProfile\" " .
	"border=\"0\" src=\"" . URL_PATH . "/images/character_profiles/" .
	(string)$character_profile[0]->attributes()->profilePicture . "\" /></a>\n";
echo "        <a href=\"" . URL_PATH . "/\" class=\"title\">\"My Immortal\"</a>\n";
/*$immortal_document = simplexml_load_file(DOCUMENT_ROOT . "/documents/character-dialogue.xml");
$quotes_by_feature_character = $immortal_document->xpath("//dialogue[@handle = '" .
	$character_profile->getHandle() . "']");
$feature_quote = $quotes_by_feature_character[array_rand($quotes_by_feature_character)];
*/echo "        <div class=\"quote\">" . (string)$feature_quote . "</div>";
echo "        <div class=\"byline\">- <a class=\"characterName\" href=\"" . URL_PATH . "/codex/entry/" . $feature_quote->attributes()->handle . "/\">" . (string)$character_profile[0] . "</a>, " .
	"<a href=\"" . URL_PATH . "/read/chapter-" . (string)$feature_quote->attributes()->chapter .
	"/\">Chapter " . (string)$feature_quote->attributes()->chapter . "</a></div>\n";
echo "        <div style=\"clear:left;\"></div>\n";
echo "      </div></div>\n";
echo "      <div class=\"headerBar\">\n";
foreach ($navigation_items as $index => $navigation_item)
{
  echo "        <a href=\"" . URL_PATH . "/" . ($navigation_item->getPageHandle() != "index" ? $navigation_item->getPageHandle() . "/" : "")  .
	"\" class=\"navLink" . ($navigation_item->getPageHandle() == $page->getHandle() ?
	" current" : "") ."\">";
  //if (in_array($navigation_item->getPageHandle(), array_keys($_PAGES)))
  //{
  //  
  //}
  echo $navigation_item->getTitle();
  echo "</a>";
  echo "\n";
}
echo "      </div>\n";
echo "      <div class=\"content\">\n";
/*echo "      <div  class=\"sidebar\">\n";
if (method_exists($page, "outputSidebar"))
  $page->outputSidebar();
echo "      </div>\n";
*/echo "      <div id=\"mainContent\" class=\"wrapper\">\n";
$page->outputBody();
echo "          <div style=\"clear:both;\"></div>\n";
echo "        </div>\n";
echo "        <div  class=\"sidebar\">\n";
echo "          <div id=\"sidebarContents\">\n";
if (method_exists($page, "outputSidebar"))
  $page->outputSidebar();
echo "          </div>\n";
echo "        </div>\n";
echo "      </div>\n";
echo "      <div class=\"footerBar\"></div>\n";
echo "      <div class=\"footer\"></div>\n";
echo "    </div>\n";
echo "  </body>\n";
echo "</html>\n";
?>
