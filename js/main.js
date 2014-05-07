
var storage = null;
var currentTarget = null;

function $id(id) {
  return document.getElementById(id);
}

function searchFiles(e) {
  if (!storage) return;
  if (currentTarget == e.target) return;

  currentTarget = e.target;

  var type = new RegExp(e.target.dataset.type);
  var files = [];
  var all_files = storage.enumerate("");
  all_files.onsuccess = function() {
    while(all_files.result) {
      var file = all_files.result;
      if (file.name.match(type)) {
        files.push(file);
      }
      all_files.continue();
    }
  };
}

function showDocs (docs) {
}

function init() {
  storage = navigator.getDeviceStorage("sdcard");
  // $id("recent").onclick = recent;
  $id("doc").onclick = searchFiles;
  $id("xls").onclick = searchFiles;
  $id("ppt").onclick = searchFiles;
}

window.addEventListener("load", init, false);
