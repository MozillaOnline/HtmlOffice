
var storage = null;
var currentTarget = null;
var loadingTimer = null;
var currentFontSize = 14;
var showZoomPanelTimer = null;
var hideZoomPanelTimer = null;
var bItemLongPressed = false;
var delayShowTimer = null;
var files = [];

function loadFiles(e) {
  if (!storage) return;
  if (currentTarget == e.target) return;

  var container = $id('list-container');
  container.innerHTML = '';
  $id('empty-list').classList.add('hidden');

  select(e.target.id);
  currentTarget = e.target;
  loading('images/loading1/');
  var type = new RegExp(e.target.dataset.type);
  searchFiles(type);
}

function searchFiles(type) {
  var all_files = storage.enumerate("");
  files = [];
  all_files.onsuccess = function() {
    while(all_files.result) {
      var file = all_files.result;
      if (file.name.match(type)) {
        files.push(file);
      }
      all_files.continue();
      if (delayShowTimer) {
        clearTimeout(delayShowTimer);
        delayShowTimer = null;
      }
    }
    delayShowFiles();
  };
}

function loading(baseUrl) {
  $id('modal-loading').classList.remove('hidden');
  var img = $id('loading-img');
  var index = 0;
  loadingTimer = setInterval(function() {
    index %= 24;
    img.src = baseUrl + index + '.png';
    index++;
  }, 100);
}

function delayShowFiles() {
  delayShowTimer  = setTimeout(showFiles, 300);
}

function showFiles () {
  if (loadingTimer) {
    clearInterval(loadingTimer);
    loadingTimer = null;
  }

  var container = $id('list-container');
  container.innerHTML = '';
  if (files.length == 0) {
    showEmptyList();
    $id('modal-loading').classList.add('hidden');
    return;
  }
  container.classList.remove('hidden');
  for (var i = 0; i < files.length; i++) {
    container.appendChild(createListItem(i));
  }
  $id('modal-loading').classList.add('hidden');
  $id('empty-list').classList.add('hidden');
}

function createListItem(index) {
  var div = document.createElement('div');
  div.classList.add('row-fluid', 'item');
  var iconDiv = document.createElement('div');
  iconDiv.classList.add('span2', 'list-title', 'doctype');
  div.appendChild(iconDiv);
  var infoDiv = document.createElement('div');
  infoDiv.classList.add('span10');
  var infoRowDiv = document.createElement('div');
  infoRowDiv.classList.add('row-fluid');
  var infoNameDiv = document.createElement('div');
  infoNameDiv.classList.add('span12', 'name');
  infoNameDiv.innerHTML = extractFileName(files[index].name);
  var infoDetailDiv = document.createElement('div');
  infoDetailDiv.classList.add('span12', 'detail');
  infoDetailDiv.innerHTML = formatDate(files[index].lastModifiedDate) + '  ' + formatFileSize(files[index].size);

  infoRowDiv.appendChild(infoNameDiv);
  infoRowDiv.appendChild(infoDetailDiv);
  infoDiv.appendChild(infoRowDiv);
  div.appendChild(iconDiv);
  div.appendChild(infoDiv);
  infoDiv.dataset.filePath = files[index].name;
  infoDiv.dataset.index = index;
  infoDiv.onclick = loadFile;
  var timer = null;
  infoDiv.onmousedown = infoDiv.ontouchstart = function() {
    bItemLongPressed = false;
    $id('fileInfo').onclick = '';
    timer = setTimeout(function() {
      bItemLongPressed = true;
      $id('modal-file-ops').classList.remove('hidden');
    }, 1500);
  };
  infoDiv.onmouseup = infoDiv.ontouchend = function() {
    console.log('mouse up');
    if (timer) {
      clearTimeout(timer);
      timer = null;
    }
    if (bItemLongPressed) {
      $id('fileInfo').dataset.index = this.dataset.index;
      $id('fileInfo').onclick = showFileInfo;
    }
  };
  return div;
}

function loadFile(event) {
  if (bItemLongPressed) return;
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('fileName').innerHTML = extractFileName(event.target.parentNode.parentNode.dataset.filePath);
  var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + extractFileName(event.target.parentNode.parentNode.dataset.filePath) +
               '" WIDTH=99.9% HEIGHT=100% FRAMEBORDER=1 scrolling="no"></IFRAME>';
  $id('container').classList.remove('hidden');
  $id('file-display').innerHTML = iframe;
}

function refresh() {
  if (!storage) return;
  if (!currentTarget) return;

  $id('list-container').innerHTML = '';
  loading('images/loading1/');
  var type = new RegExp(currentTarget.dataset.type);
  searchFiles(type);
}

function select(id) {
  $id('recent').classList.remove('selected');
  $id('doc').classList.remove('selected');
  $id('xls').classList.remove('selected');
  $id('ppt').classList.remove('selected');
  $id(id).classList.add('selected');
}

function showEmptyList() {
  $id('empty-list').classList.remove('hidden');
}

function goBack() {
  $id('list-header').classList.remove('hidden');
  $id('list-container').classList.remove('hidden');
  $id('file-info').classList.add('hidden');
  $id('container').classList.add('hidden');
  $id('file-display').innerHTML = '';
}

function zoomIn() {
  if (currentFontSize < 30)  currentFontSize += 5;
  $id('file-display').style.fontSize = currentFontSize + 'px';
  hideZoomPanel();
}

function zoomOut() {
  if (currentFontSize > 10)  currentFontSize -= 5;
  $id('file-display').style.fontSize = currentFontSize + 'px';
  hideZoomPanel();
}

function hideZoomPanel() {
  if (hideZoomPanelTimer) {
    clearTimeout(hideZoomPanelTimer);
    hideZoomPanelTimer = null;
  }
  hideZoomPanelTimer = setTimeout(function() {
    $id('footer').classList.add('hidden');
    hideZoomPanelTimer = null;
  }, 3000);
}

function showFileInfo() {
  $id('modal-file-ops').classList.add('hidden');
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
 // $id('file-container').classList.remove('hidden');
  $id('file-display').classList.add('hidden');
  var index = parseInt(this.dataset.index);

  $id('name').innerHTML = $id('file-info').dataset.name = extractFileName(files[index].name);
  $id('size').innerHTML = formatFileSize(files[index].size);
  $id('dir').innerHTML = files[index].name;
  $id('lastModify').innerHTML = formatDate(files[index].lastModifiedDate);
  $id('file-info').classList.remove('hidden');
  $id('open').onclick = function() {
    $id('list-header').classList.add('hidden');
    $id('list-container').classList.add('hidden');
    $id('fileName').innerHTML = extractFileName($id('file-info').dataset.name);
    var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + extractFileName($id('file-info').dataset.name) +
                 '" WIDTH=99.9% HEIGHT=100% FRAMEBORDER=1 scrolling="no"></IFRAME>';
    $id('container').classList.remove('hidden');
    $id('file-display').classList.remove('hidden');
    $id('file-display').innerHTML = iframe;
    $id('file-info').classList.add('hidden');
  };

}

function init() {
  storage = navigator.getDeviceStorage("sdcard");
  $id("recent").onclick = recent;
  $id('doc').onclick = loadFiles;
  $id('xls').onclick = loadFiles;
  $id('ppt').onclick = loadFiles;
  $id('goback').onclick = goBack;
  $id('refresh').onclick = refresh;
  /*
  $id('file-display').onmousedown = function() {
    showZoomPanelTimer = setTimeout(function() {
      $id('footer').classList.remove('hidden');
      hideZoomPanel();
    }, 1500);
  };
  $id('file-display').onmouseup = function() {
    if (showZoomPanelTimer) {
      clearTimeout(showZoomPanelTimer);
      showZoomPanelTimer = null;
    }
  };
  */
  // $id('zoom-in').onclick = zoomIn;
  // $id('zoom-out').onclick = zoomOut;
}

window.addEventListener("load", init, false);
