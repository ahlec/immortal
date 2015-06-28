<?php
class Download
{
  private $_files = array();
  function checkOrRedirect($path_pieces)
  {
    $files = glob(DOCUMENT_ROOT . "/documents/*.*");
    $files = array_merge($files, glob(DOCUMENT_ROOT . "/addon-styles/*.*"));
    $files[] = DOCUMENT_ROOT . "/stylesheet.css";
    foreach ($files as $file)
    {
      $fileinfo = pathinfo($file);
      $fileArray = array("LAST_MODIFIED" => filectime($file),
	"FILENAME" => str_replace(DOCUMENT_ROOT . "/", "", $file),
	"NAME" => str_replace($fileinfo["dirname"] . "/", "", $file), "SIZE" => filesize($file));
      if (isset($this->_files[$fileinfo["extension"]]))
        $this->_files[$fileinfo["extension"]][] = $fileArray;
      else
        $this->_files[$fileinfo["extension"]] = array($fileArray);
    }
    ksort($this->_files);
    return true;
  }
  public static function sortFiles($a, $b)
  {
    if ($a["LAST_MODIFIED"] == $b["LAST_MODIFIED"])
      return 0;
    return ($a["LAST_MODIFIED"] > $b["LAST_MODIFIED"] ? -1 : 1);
  }
  function getHandle() { return "download"; } 
  function getTitle() { return "Download Files"; }
  function outputSidebar()
  {
    echo "<h1 class=\"first\">Project File</h1>\n";
    echo "<center>\n";
    echo "<a href=\"" . URL_PATH . "/documents/immortal.xml\" target=\"_blank\"><img src=\"" .
	URL_PATH . "/images/download icon.png\" border=\"0\"/><br />immortal.xml</a>\n";
    echo "</center>\n";
  }
  function outputBody()
  {
    echo "<h1>Downloads</h1>\n";
    echo "Our repository of project files, available to the community. Files are sorted by filetype, then by date they were last modified.\n";
    foreach ($this->_files as $filetype => $files)
    {
      usort($files, array("Download", "sortFiles"));
      echo "<h2>." . $filetype . "</h2>\n";
      foreach ($files as $file)
      {
        echo "  <div class=\"downloadListEntry\">\n";
        echo "    <a href=\"" . URL_PATH . "/" . $file["FILENAME"] .
		"\" target=\"_blank\">" . $file["NAME"] . "</a>\n";
	echo "    <span>(<b>Last modified</b> " . date(DATETIME_FORMAT, $file["LAST_MODIFIED"]) .
		")</span>\n";
	echo "  </div>\n";
      }
    }
  }
}
?>
