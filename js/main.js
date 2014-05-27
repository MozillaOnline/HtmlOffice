
var storage = null;
var currentTarget = null;
var loaded = false;
var loadingTimer = null;
var bItemLongPressed = false;
var bTouchMoved = false;
var delayShowTimer = null;
var files = [];
var db = null;

const MAX_COUNT = 10;

function loadFiles(e) {
  $id('refresh').dataset.disabled = 'false';
  if (!storage) return;
  if (currentTarget == e.target) return;

  var container = $id('list-container');
  container.innerHTML = '';
  $id('empty-list').classList.add('hidden');

  select(e.target.id);
  currentTarget = e.target;
  loading('images/loading1/');
  var type = new RegExp(e.target.dataset.type + '$');
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
  $id('loading-container').style.marginTop = ($id('modal-loading').clientHeight/2 - 50) + 'px';
  var img = $id('loading-img');
  var index = 0;
  loadingTimer = setInterval(function() {
    index %= 24;
    img.src = baseUrl + index + '.png';
    index++;
    if (loadingTimer && loaded) {
      clearInterval(loadingTimer);
      loadingTimer = null;
      loaded = false;
    }
  }, 100);
}

function delayShowFiles() {
  delayShowTimer  = setTimeout(showFiles, 300);
}

function showFiles () {
  var container = $id('list-container');
  container.innerHTML = '';
  if (files.length == 0) {
    loaded = true;
    showEmptyList();
    $id('modal-loading').classList.add('hidden');
    return;
  }
  container.classList.remove('hidden');
  for (var i = 0; i < files.length; i++) {
    container.appendChild(createListItem(i));
  }
  loaded = true;
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
    bTouchMoved = false;
    $id('modal-file-ops').onclick = '';
    var self = this;
    timer = setTimeout(function() {
      bItemLongPressed = true;
      if (bTouchMoved) return;
      $id('file-ops-dlg').classList.remove('hidden');
      $id('fileName').innerHTML = extractFileName(files[self.dataset.index].name);
      $id('deleteFileName').innerHTML = 'Dekete ' + extractFileName(files[self.dataset.index].name) + '?';
      $id('delete-confirm').classList.add('hidden');
      $id('modal-file-ops').classList.remove('hidden');
      $id('file-ops-container').style.marginTop = ($id('modal-file-ops').clientHeight/2 - 60) + 'px';
    }, 1000);
  };

  infoDiv.onmouseup = infoDiv.ontouchend = function() {
    console.log('mouse up');
    if (timer) {
      clearTimeout(timer);
      timer = null;
    }
    if (bItemLongPressed && !bTouchMoved) {
      $id('modal-file-ops').dataset.index = this.dataset.index;
      setTimeout(function() {
        $id('modal-file-ops').onclick = function(evt) {
          if (evt.target.id == 'fileName') return;

          if (evt.target.id == 'fileInfo') {
            $id('modal-file-ops').classList.add('hidden');
            showFileInfo();
            return;
          }
          if (evt.target.id == 'deleteFile') {
            $id('file-ops-dlg').classList.add('hidden');
            $id('delete-confirm').classList.remove('hidden');
            return;
          }

          if (evt.target.id == 'cancel') {
            $id('file-ops-dlg').classList.remove('hidden');
            $id('delete-confirm').classList.add('hidden');
            return;
          }
          if (evt.target.id == 'confirm') {
            $id('modal-file-ops').classList.add('hidden');
            //deleteFile();
            return;
          }

          if ($id('delete-confirm').classList.contains('hidden')) {
            $id('modal-file-ops').classList.add('hidden');
          }
        };
      }, 500);
    }
  };
  return div;
}

function loadFile(event) {
  if (bItemLongPressed) return;
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('documentName').innerHTML = extractFileName(event.target.parentNode.parentNode.dataset.filePath);
  $id('container').classList.remove('hidden');
  loading('images/loading1/');
  var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + event.target.parentNode.parentNode.dataset.filePath +
               '" WIDTH=100% HEIGHT=100% FRAMEBORDER=0 scrolling="no"></IFRAME>';
  $id('file-display').innerHTML = iframe;
}

function refresh() {
  if (!storage) return;
  if (!currentTarget) return;

  $id('list-container').innerHTML = '';
  loading('images/loading1/');

  if (currentTarget.id == 'history') {
    updateHistory();
    return;
  }

  var type = new RegExp(currentTarget.dataset.type);
  searchFiles(type);
}

function select(id) {
  $id('history').classList.remove('selected');
  $id('doc').classList.remove('selected');
  $id('xls').classList.remove('selected');
  $id('ppt').classList.remove('selected');
  $id(id).classList.add('selected');
}

function showEmptyList() {
  $id('list-container').classList.add('hidden');
  $id('empty-list').classList.remove('hidden');
}

function goBack() {
  $id('list-header').classList.remove('hidden');
  $id('list-container').classList.remove('hidden');
  $id('file-info').classList.add('hidden');
  $id('container').classList.add('hidden');
  $id('file-display').innerHTML = '';

}

function showFileInfo() {
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('file-display').classList.add('hidden');
  var index = parseInt($id('modal-file-ops').dataset.index);
  $id('file-info').dataset.name = files[index].name;

  $id('name').innerHTML = extractFileName(files[index].name);
  $id('size').innerHTML = formatFileSize(files[index].size);
  $id('dir').innerHTML = files[index].name;
  $id('lastModify').innerHTML = formatDate(files[index].lastModifiedDate);
  $id('file-info').classList.remove('hidden');
  $id('open').onclick = function() {
    $id('file-info').classList.add('hidden');
    $id('list-header').classList.add('hidden');
    $id('list-container').classList.add('hidden');
    $id('documentName').innerHTML = extractFileName($id('file-info').dataset.name);
    $id('container').classList.remove('hidden');
    loading('images/loading1/');
    var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + $id('file-info').dataset.name +
                 '" WIDTH=100% HEIGHT=100% FRAMEBORDER=0 scrolling="no"></IFRAME>';
    $id('file-display').innerHTML = iframe;
  };
}

function deleteFile() {
  var index = parseInt($id('modal-file-ops').dataset.index);
  var req =  storage.delete(files[index].name);
  req.onsuccess = function() {
    var container = $id('list-container');
    var items = container.querySelectorAll('.item');
    for (var i = 0; i < items.length; i++) {
      if (items[i].lastChild.dataset.index == index) {
        container.removeChild(items[i]);
      }
    }
  };
  req.onerror = function(e) {
    console.log('delete file failed:' + e.name);
  };
}

function showHistory(e) {
  $id('refresh').dataset.disabled = 'true';
  if (!db) return;
  if (currentTarget == e.target) return;

  select(e.target.id);
  currentTarget = e.target;

  var container = $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');

  loading('images/loading1/');
  updateHistory();
}

function updateHistory() {
  if (!db) return;

  files = [];
  var count = 0;
  var tx = db.transaction(["files"], "readwrite");
  var store = tx.objectStore("files");
  var index = store.index('lastAccessDate');
  index.openCursor(null, 'prev').onsuccess = function(event) {
    var cursor = event.target.result;
    if (cursor) {
      count++;
      if (count < MAX_COUNT) {
        files.push({
          name: cursor.value.name,
          size: cursor.value.size,
          lastModifiedDate: cursor.value.lastModifiedDate
        });
      } else {
        // TODO remove all the other entries
      }
      cursor.continue();
    }
    showFiles();
  };
}

function init() {
  storage = navigator.getDeviceStorage("sdcard");
  $id("history").onclick = showHistory;
  $id('doc').onclick = loadFiles;
  $id('xls').onclick = loadFiles;
  $id('ppt').onclick = loadFiles;
  $id('goback').onclick = goBack;
  $id('refresh').onclick = refresh;
  $id('quitViewer').onclick = function() {
    $id('list-header').classList.remove('hidden');
    $id('list-container').classList.remove('hidden');
    $id('container').classList.add('hidden');
    $id('file-display').innerHTML = '';
    if (currentTarget.id == 'history') {
      loading('images/loading1/');
      updateHistory();
    }
  };
  window.onresize = function() {
    $id('loading-container').style.marginTop = ($id('modal-loading').clientHeight/2 - 50) + 'px';
    $id('file-ops-container').style.marginTop = ($id('modal-file-ops').clientHeight/2 - 50) + 'px';
  };

  var request = indexedDB.open("history");

  request.onupgradeneeded = function(event) {
    db = event.target.result;
    var store = db.createObjectStore("files", { keyPath: "name" });
    store.createIndex('lastAccessDate', 'lastAccessDate', { unique: true });
    console.log("indexedDB upgraded");
  }

  request.onsuccess = function(event) {
    db = event.target.result;
    console.log('open indexedDB successfully');
  };

  $id('list-container').ontouchstart = function(evt) {
    console.log('touch start');
  };
  $id('list-container').ontouchmove = function(evt) {
    bTouchMoved = true;
    console.log('touch move');
  };
  $id('list-container').ontouchend = function(evt) {
    console.log('touch end');
  };

  $id('doc').click();
}

window.addEventListener("load", init, false);
