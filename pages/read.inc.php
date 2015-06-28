<?php
class Read
{
  private $_numberOfTotalChapters;
  private $_chapterNumber;
  private $_immortalDocument;
  private $_chapterXML;
  private $_xsltProcessor;
  private $_readingOriginal = true;
  private $_usePopups = true;
  private $_useKeyboardNav = true;
  function checkOrRedirect($path_pieces)
  {
    if (!isset($_SESSION[READ_SETTINGS_SESSION]))
      $_SESSION[READ_SETTINGS_SESSION] = array('originalVersion' => true, 'keyboard' => true, 'popup' => true);
    if (isset($path_pieces[2]) && (strtolower($path_pieces[2]) == "revised" || strtolower($path_pieces[2]) == "original"))
      $_SESSION[READ_SETTINGS_SESSION]['originalVersion'] = (strtolower($path_pieces[2]) == "original");
    if (isset($path_pieces[2]) && (strtolower($path_pieces[2]) == "show-popups" || strtolower($path_pieces[2]) == "hide-popups"))
      $_SESSION[READ_SETTINGS_SESSION]['popup'] = (strtolower($path_pieces[2]) == "show-popups");
    if (isset($path_pieces[2]) && (strtolower($path_pieces[2]) == "use-keyboard" || strtolower($path_pieces[2]) == "disable-keyboard"))
      $_SESSION[READ_SETTINGS_SESSION]['keyboard'] = (strtolower($path_pieces[2]) == "use-keyboard");
    $this->_readingOriginal = $_SESSION[READ_SETTINGS_SESSION]['originalVersion'];
    $this->_usePopups = $_SESSION[READ_SETTINGS_SESSION]['popup'];
    $this->_useKeyboardNav = $_SESSION[READ_SETTINGS_SESSION]['keyboard'];
    if (isset($path_pieces[1]) && ctype_digit(str_replace("chapter-", "", mb_strtolower($path_pieces[1]))))
    {
      $this->_chapterNumber = str_replace("chapter-", "", mb_strtolower($path_pieces[1]));
    } else
      $this->_chapterNumber = 1;
    if ($this->_chapterNumber < 1)
      $this->_chapterNumber = 1;
    $this->_immortalDocument = @simplexml_load_file(DOCUMENT_ROOT . "/" . XML_DOCUMENT);
    $this->_numberOfTotalChapters = sizeof($this->_immortalDocument->story[0]->chapter);
    if ($this->_chapterNumber > sizeof($this->_immortalDocument->story[0]->chapter))
      $this->_chapterNumber = 1;
    if (isset($path_pieces[2]) && strlen($path_pieces[2]) > 0)// && (strtolower($path_pieces[2]) == "revised" || strtolower($path_pieces[2]) == "original"))
    {
      header("Location: " . URL_PATH . "/read/chapter-" . $this->_chapterNumber . "/");
      exit();
    }
    $this->_chapterXML = $this->_immortalDocument->xpath("//chapter[" . $this->_chapterNumber . "]");
    $this->_chapterXML = $this->_chapterXML[0];
    $chapterStyleSheet = new DOMDocument();
    $chapterStyleSheet->load(DOCUMENT_ROOT . "/documents/read chapter.xsl");
    $this->_xsltProcessor = new XSLTProcessor();
    $this->_xsltProcessor->registerPHPFunctions();
    $this->_xsltProcessor->setParameter('', 'urlPath', URL_PATH);
    $this->_xsltProcessor->setParameter('', 'readingOriginal',
	($this->_readingOriginal ? "true" : "false"));
    $this->_xsltProcessor->setParameter('', 'showPopups', ($this->_usePopups ? "true" : "false"));
    $this->_xsltProcessor->importStylesheet($chapterStyleSheet);
    return true;
  }
  function getHandle() { return "read"; }
  function getTitle() { return ("Chapter " . $this->_chapterNumber); }
  function outputHEAD()
  {
    echo "<script>
function navigateChapters(e)
{
  if (!e) var e = window.event;";
    if ($this->_chapterNumber + 1 <= $this->_numberOfTotalChapters)
      echo "  if (e.keyCode == 39)
    window.location = '" . URL_PATH . "/read/chapter-" . ($this->_chapterNumber + 1) . "/';";
    if ($this->_chapterNumber - 1 > 0)
      echo "  if (e.keyCode == 37)
    window.location = '" . URL_PATH . "/read/chapter-" . ($this->_chapterNumber - 1) . "/';";
echo "}
</script>\n";
  }
  function getBODYAppend() { return ($this->_useKeyboardNav ? "onkeydown='navigateChapters(event)'" : null); }
  function outputSidebar()
  {
    echo "<h1 class=\"first\">Chapters</h1>\n";
    echo "  <div class=\"readNavigation\">\n";
    for ($chapterNumber = 1; $chapterNumber <= $this->_numberOfTotalChapters; $chapterNumber++)
      echo "    " . ($chapterNumber != $this->_chapterNumber ? "<a href=\"" .
        URL_PATH . "/read/chapter-" . $chapterNumber . "/\" " : "<div ") .
        "class=\"item" . ($chapterNumber == 39 ? " hack" : "") . "\">" . $chapterNumber . ($chapterNumber
        != $this->_chapterNumber ? "</a>" : "</div>") . "\n";
    echo "  </div>\n";
    echo "  <h1>Reading Version</h1>\n";
    echo "  <a href=\"" . URL_PATH . "/read/chapter-" . $this->_chapterNumber . "/original/\" class=\"readStyleButton original " .
	($this->_readingOriginal ? "selected" : "unselected") . "\">Original</a>";
    echo "<a href=\"" . URL_PATH . "/read/chapter-" . $this->_chapterNumber . "/revised/\" class=\"readStyleButton revised " .
	($this->_readingOriginal ? "unselected" : "selected") . "\">Revised</a>\n";
    echo "  <h1>Reading Options</h1>\n";
    echo "  <div class=\"readOption\"><input type=\"checkbox\" id=\"use-codex-links\" " .
	($this->_usePopups ? "checked=\"checked\" " : "") . "onclick=\"window.location = '" . URL_PATH .
	"/read/chapter-" . $this->_chapterNumber . "/' + (this.checked ? 'show-popups' : 'hide-popups');\" /> <label for=\"use-codex-links\">Show Popups</label></div>\n";
    echo "  <div class=\"readOption\"><input type=\"checkbox\" id=\"use-keyboard-navigation\" " .
	($this->_useKeyboardNav ? "checked=\"checked\" " : "") . "onclick=\"window.location='" . URL_PATH .
	"/read/chapter-" . $this->_chapterNumber . "/' + (this.checked ? 'use-keyboard' : 'disable-keyboard');\" /> <label for=\"use-keyboard-navigation\">Keyboard Navigation</label></div>\n";
  }
  function outputBody()
  {
    echo "<div class=\"read\">\n";
    $chapterXMLDOM = new DOMDocument();
    $chapterXMLDOM->loadXML($this->_chapterXML->asXML());
    $this->_xsltProcessor->transformToURI($chapterXMLDOM, "php://output");
    if ($this->_chapterNumber < $this->_numberOfTotalChapters)
      echo "<a href=\"" . URL_PATH . "/read/chapter-" . ($this->_chapterNumber + 1) . "/\" class=\"nextChapter\">Next Chapter &rarr;</a>\n";
    echo "</div>\n";
  }
}
?>
