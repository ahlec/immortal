function Dialog(target_element, bindings, x, y)
{
  var dialog = this;
  var divElement = document.createElement("div");
  divElement.className = "dialogWindow";
  //divElement.style.left = x + "px";
  //divElement.style.top = y + "px";
  //document.body.appendChild(divElement);
  target_element.appendChild(divElement);

 /* var dialogTitle = document.createElement("div");
  dialogTitle.className = "title";
  dialogTitle.innerHTML = (target_element.textContent ? target_element.textContent : target_element.innerText);
  divElement.appendChild(dialogTitle);
*/
  var identifiers = new Array("char", "Characters", "ref", "References", "place", "Locations", "spell", "Spells",
	"chapter", "Chapter", "sp", "Spelling Mistakes", "grammar", "Grammar Mistakes");
  var dialogBody = document.createElement("div");
  var previousType = null;
  var typeCodexLink = null;
  var previousTypeHandles = new Array();  
  for (var index = 0; index < bindings.length; index++)
  { 
    if (previousType != bindings[index][1])
    {
      previousType = bindings[index][1];
      previousTypeHandles = new Array();
      var identifyingHeader = document.createElement("div");
      identifyingHeader.className = "identifyingHeader";
      for (var identifierIndex = 0; identifierIndex < identifiers.length; identifierIndex++)
        if (identifiers[identifierIndex] == bindings[index][1])
        {
          identifyingHeader.innerHTML = identifiers[identifierIndex + 1];
          typeCodexLink = identifiers[identifierIndex + 1].toLowerCase();
        }
      dialogBody.appendChild(identifyingHeader);
    }
    var separatedHandles = (bindings[index][0] == "link" ? bindings[index][2].split(" ") : new Array(bindings[index][2]));
    for (var handleIndex = 0; handleIndex < separatedHandles.length; handleIndex++)
    {
      if (previousTypeHandles.indexOf(separatedHandles[handleIndex]) < 0)
      {
        var entry = document.createElement("div");
        entry.className = "entry" + (bindings[index][0] == "correction" ? " correction" : "");
        var codexLink = (bindings[index][0] == "link" ? document.createElement("a") : document.createElement("span"));
        if (bindings[index][0] == "link")
        {        
          codexLink.href = URL_PATH + "/codex/entry/" + separatedHandles[handleIndex] + "/";
          codexLink.innerHTML = translateHandleToText(separatedHandles[handleIndex]);
        } else
          codexLink.innerHTML = "Intended: " + separatedHandles[handleIndex];
        var contextData = document.createElement("span");
        contextData.innerHTML = "(" + (bindings[index][0] == "correction" ? "Type: " + bindings[index][3] + ", " : "") + "&quot;" +
		bindings[index][(bindings[index][0] == "link" ? 3 : 4)] + "&quot;)";
        entry.appendChild(codexLink);
        entry.appendChild(contextData);
        dialogBody.appendChild(entry);
        previousTypeHandles.push(separatedHandles[handleIndex]);
      }
    }
  }  
divElement.appendChild(dialogBody);

  this.close = function()
  {
    if (!divElement.parentNode)
      return;
    openDialog = null;
    target_element.hasDialog = false;
    target_element.removeChild(divElement);   
// document.body.removeChild(divElement);
    target_element.onmouseout = function() { }
    target_element.className = target_element.className.replace(" dialogTarget", "");
    var parentElements = target_element;
    while (parentElements.parentNode)
    {
      if (parentElements.className && parentElements.className.indexOf("dialogCollat") >= 0)
        parentElements.className = parentElements.className.replace(" dialogCollat", "");
      parentElements = parentElements.parentNode;
    }
  }
  this.processMouseOut = function(e)
  {
   if (!e) var e = window.event;
   var target = (e.relatedTarget ? e.relatedTarget : e.toElement);
   if (target == divElement || target == target_element)
     return;
   while (target.parentNode)
   {
     if (target == divElement)
       return;
     target = target.parentNode;
   }
   // target_element.onmouseout = function() { }
    dialog.close();
  }
  target_element.hasDialog = true;
  divElement.onmouseout = this.processMouseOut;
  target_element.onmouseout = this.processMouseOut;
  target_element.className += " dialogTarget";
  var parentElements = target_element;
  while (parentElements.parentNode)
  {
    if (parentElements.className && parentElements.className.indexOf("dialogObject") >= 0)
      parentElements.className += " dialogCollat";
    parentElements = parentElements.parentNode;
  }
}
var openDialog = null;
Dialog.create = function(e, target_element)
{
  if (target_element.hasDialog)
    return;
  if (openDialog != null)
  {
    for (var index = 0; index < target_element.childNodes.length; index++)
      if (target_element.childNodes[index].hasDialog)
        return;
    openDialog.close();
  }
  if (!e) var e = window.event;
  if (e.stopPropagation)
    e.stopPropagation();
  else
    e.cancelBubble = true;
  var bindings = new Array();
  var currentElement = target_element;
  while (currentElement.getAttribute)
  {
    if (currentElement.getAttribute('handle') || currentElement.getAttribute('intended'))
    {
     /*var inContainer = false;
     var containerChild = null;
     var containerIterator = currentElement;
     while (containerIterator.parentNode)
     {
       if (containerIterator.parentNode.nodeName.toLowerCase() == 'container')
       {
         inContainer = true;
         containerChild = containerIterator;
         break;
       }
       containerIterator = containerIterator.parentNode;
     }*/
     var followingText = "";//"...";
     var precedingText = "";//"...";
     /*if (inContainer)
     {
       precedingText = "";
       var precedingIterator = containerChild.previousSibling;
       while (precedingIterator && precedingIterator.previousSibling)
       {
         if ((precedingIterator.textContent ? precedingIterator.textContent : precedingIterator.innerText).replace(/[^a-zA-Z0-9]/, "").length > 0)
         {
           precedingText = "...";
           break;
         }
         precedingIterator = precedingIterator.previousSibling;
       }
       followingText = "";
       var followingIterator = containerChild.nextSibling;
       while (followingIterator && followingIterator.nextSibling)
       {
         if ((followingIterator.textContent ? followingIterator.textContent : followingIterator.innerText).replace(/[^a-zA-Z0-9]/, "").length > 0)
         {
           followingText = "...";
           break;
         }
         followingIterator = followingIterator.nextSibling;
       }
     }*/
      if (currentElement.getAttribute('handle'))
        bindings.push(new Array("link", currentElement.getAttribute('elementName'),
	  currentElement.getAttribute('handle'), precedingText +
	  (currentElement.textContent ? currentElement.textContent : currentElement.innerText) + followingText));
      else if (currentElement.getAttribute('intended'))
        bindings.push(new Array("correction", currentElement.getAttribute('elementName'),
	  currentElement.getAttribute('intended'), currentElement.getAttribute('type'), precedingText +
	  (currentElement.getAttribute('targetText') ?
	  currentElement.getAttribute('targetText') :
	  (currentElement.textContent ? currentElement.textContent : currentElement.innerText) + followingText)));
    }
    currentElement = currentElement.parentNode;
  }
  bindings.sort(sortBindings);
  var newDialog = new Dialog(target_element, bindings);//,
  openDialog = newDialog;
}
function sortBindings(a, b)
{
  var displayOrders = new Array("sp", "grammar", "chapter", "char", "ref", "place", "spell");
  var aTranslate = displayOrders.indexOf(a[1]);
  var bTranslate = displayOrders.indexOf(b[1]);
  return aTranslate - bTranslate;
}
