var sidebarHeightCheckTimer = setTimeout("checkSidebarHeight()", 100);
function sidebarResized(e)
{
  if (!e) var e = window.event;
  document.title = count++;
}
function checkSidebarHeight()
{
  if (!document.getElementById("sidebarContents") || !document.getElementById("mainContent"))
    return;
  if (document.getElementById("sidebarContents").clientHeight > document.getElementById("mainContent").clientHeight)
    document.getElementById("mainContent").style.height = document.getElementById("sidebarContents").clientHeight + "px";
  else if (document.getElementById("sidebarContents").clientHeight + 45 < document.getElementById("mainContent").clientHeight)
    document.getElementById("mainContent").style.height = "auto";
  sidebarHeightCheckTimer = setTimeout("checkSidebarHeight()", 100);
}
