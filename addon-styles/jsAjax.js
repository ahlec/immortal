function executeAJAX(ajaxcall, evaluate_function)
{
  var AJAX;
  try
  {
    AJAX = new XMLHttpRequest();
  }
  catch(e)
  {
    try
    {
      AJAX = new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch(e)
    {
      try
      {
        AJAX = new ActiveXObject("Microsoft.XMLHTTP");
      }
      catch(e)
      {
        alert("Your browser does not support AJAX.");
        return false;
      }
    }
  }
  AJAX.onreadystatechange = function()
  {
    if (AJAX.readyState == 4)
      if (AJAX.status == 200)
        evaluate_function(AJAX.responseText);
      else
        alert("Error: " + AJAX.statusText + ". " + AJAX.status);
  }
  AJAX.open("get", ajaxcall, true);
  AJAX.send(null);
}
