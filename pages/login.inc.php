<?php
class Login 
{
  private $_loginAttempted = false;
  private $_loginFailed = false;
  function checkOrRedirect($path_pieces)
  {
    if (isset($_POST["username"]) && isset($_POST["password"]))
    {
      $this->_loginAttempted = true;
      $username = $_POST["username"];
      $password = md5($_POST["password"]);
      $user_file = simplexml_load_file(DOCUMENT_ROOT . "/db/users.xml");
      foreach ($user_file->children() as $userDefinition)
      {
        if ((string)($userDefinition->handle) === $username &&
		(string)($userDefinition->password) === $password)
	{
          $_SESSION[USER_SESSION] = (string)$userDefinition->handle;
	  header("Location: " . URL_PATH . "/");
	  exit();
	}
      }
      $this->_loginFailed = true;
    }
    return true;
  }
  function getHandle() { return "login"; } 
  function getTitle() { return "Login"; }
  function outputSidebar()
  {
  }
  function outputBody()
  {
    if (!isset($_SESSION[USER_SESSION]))
    {
      if ($this->_loginAttempted && $this->_loginFailed)
        echo "<div style=\"background-color:paleread;\"><b>The username/password combination you provided is incorrect. Please try again. Or don't. It doesn't really matter to me if you get in or not.</b></div>\n";
      echo "<h1>Login</h1>\n";
      echo "<form method=\"post\">\n";
      echo "<b>Username:</b> <input type=\"text\" name=\"username\" /><br />\n";
      echo "<b>Password:</b> <input type=\"password\" name=\"password\" /><br />\n";
      echo "<input type=\"submit\" value=\"Login\" />\n";
      echo "</form>\n";
    } else
    {
      echo "You are currently logged in as <b>" . $_SESSION[USER_SESSION] . "</b>.\n";
    }
  }
}
?>
