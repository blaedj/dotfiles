// ==UserScript==
// @name           Disable keyboard shortcuts
// @description    Stop websites from highjacking keyboard shortcuts
//
// @run-at         document-start
// @include        *github.com*
// @grant          none
// ==/UserScript==

keys = ["Control"]

document.addEventListener('keydown', function(e) {
  // alert(e.key); //uncomment to find out the keycode for any given key
  if (keys.indexOf(e.key) != -1 || e.ctrlKey)
  {
    e.cancelBubble = true;
    e.stopImmediatePropagation();
  }
  return false;
})
