function codexNavToggle(section)
{
  if (openedNavSection != null || openedNavSection == section)
  {
    var prevNavSection = openedNavSection;
    document.getElementById("codex-nav-" + openedNavSection).className = "codexNavContainer collapsed";
    openedNavSection = null;
    if (prevNavSection == section)
    {
      window.scroll(0,0);
      return;
    }
  }
  document.getElementById("codex-nav-" + section).className = "codexNavContainer";
  if (document.body.scrollTop >= 170)
  {
    window.location.hash = "codex-nav-" + section;
    //window.scrollBy(0, -26);
  }
  openedNavSection = section;
}
