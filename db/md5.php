<?php
if (!isset($_SERVER["argv"][1]))
  exit ("Must pass through a parameter for the string that you wish to have encoded into MD5 encryption.");
echo md5($_SERVER["argv"][1]);
?>
