<?php
class Logout 
{
  function checkOrRedirect($path_pieces)
  {
    if (isset($_SESSION[USER_SESSION]))
      unset($_SESSION[USER_SESSION]);
    return new Index();
  }
  function getHandle() { return "logout"; } 
  function getTitle() { return "Logout"; }
  function outputBody()
  {
    echo "logout";
  }
}
?>
