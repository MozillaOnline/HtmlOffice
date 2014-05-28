
var storage = null;
var currentTarget = null;
var loaded = false;
var loadingTimer = null;
var bItemLongPressed = false;
var bTouchMoved = false;

var filesContainer = {
  docx: [],
  xls: [],
  ppt: [],
  docxLoaded: false,
  xlsLoaded: false,
  pptLoaded: false
};

var db = null;

const MAX_COUNT = 10;

function loadFiles(evt) {
  if (!storage) return;
  if (currentTarget == evt.target) return;
  $id('refresh').dataset.disabled = 'false';

  currentTarget = evt.target;
  select(currentTarget);
  $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');

  var type = currentTarget.dataset.type;
  var loaded = type + 'Loaded';
  if (filesContainer[loaded]) {
    showFiles(type);
    return;
  }
  searchFiles(type);
  filesContainer[loaded] = true;
}

function searchFiles(type) {
  loading('images/loading1/');
  filesContainer[type] = [];
  var reg = new RegExp(type + '$');
  var cursor = storage.enumerate('');
  cursor.onsuccess = function() {
    if (cursor.result == null) {
      showFiles(type);
      return;
    }
    if (cursor.result) {
      var file = cursor.result;
      if (file.name.match(reg)) {
        filesContainer[type].push(file);
      }
      cursor.continue();
    }
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
  }, 500);
}

function showFiles(type) {
  var container = $id('list-container');
  container.innerHTML = '';
  if (filesContainer[type].length == 0) {
    loaded = true;
    showEmptyList();
    $id('modal-loading').classList.add('hidden');
    return;
  }
  container.classList.remove('hidden');
  for (var i = 0; i < filesContainer[type].length; i++) {
    container.appendChild(createListItem(i, type));
  }
  loaded = true;
  $id('modal-loading').classList.add('hidden');
  $id('empty-list').classList.add('hidden');
}

function createListItem(index, type) {
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
  infoNameDiv.innerHTML = extractFileName(filesContainer[type][index].name);
  var infoDetailDiv = document.createElement('div');
  infoDetailDiv.classList.add('span12', 'detail');
  infoDetailDiv.innerHTML = formatDate(filesContainer[type][index].lastModifiedDate) + '  ' + formatFileSize(filesContainer[type][index].size);

  infoRowDiv.appendChild(infoNameDiv);
  infoRowDiv.appendChild(infoDetailDiv);
  infoDiv.appendChild(infoRowDiv);
  div.appendChild(iconDiv);
  div.appendChild(infoDiv);
  infoDiv.dataset.filePath = filesContainer[type][index].name;
  infoDiv.dataset.index = index;
  infoDiv.dataset.type = type;
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
      $id('fileName').innerHTML = extractFileName(filesContainer[type][self.dataset.index].name);
      $id('deleteFileName').innerHTML = 'Dekete ' + extractFileName(filesContainer[type][self.dataset.index].name) + '?';
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
      $id('modal-file-ops').dataset.type = this.dataset.type;
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
  if (!storage || !currentTarget) return;
  if (currentTarget.id == 'history') {
    // updateHistory();
    return;
  }

  $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');
  loading('images/loading1/');

  var type = currentTarget.dataset.type;
  var loaded = type + 'Loaded';
  searchFiles(type);
  filesContainer[loaded] = true;
}

function select(target) {
  $id('history').classList.remove('selected');
  $id('doc').classList.remove('selected');
  $id('xls').classList.remove('selected');
  $id('ppt').classList.remove('selected');
  $id(target.id).classList.add('selected');
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
  var files;
  switch ($id('modal-file-ops').dataset.type) {
    case 'docx':
      files = docFiles;
      break;
    case 'xls':
      files = xlsFiles;
      break;
    case 'ppt':
      files = pptFiles;
      break;
  }

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

function showHistory(evt) {
  $id('refresh').dataset.disabled = 'true';
  if (!db) return;
  if (currentTarget == evt.target) return;

  select(currentTarget);
  currentTarget = evt.target;

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

  //$id('doc').click();
}

window.addEventListener("load", init, false);
