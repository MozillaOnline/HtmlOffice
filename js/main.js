
var db = null;
var storages = null;
var currentTarget = null;
var bItemLongPressed = false;
var bTouchMoved = false;
var bDisplayDoc = false;
const MAX_COUNT = 10;

var filesContainer = {
  history: [],
  docx: [],
  xlsx: [],
  pptx: [],
  docxLoaded: false,
  xlsxLoaded: false,
  pptxLoaded: false
};

function loadFiles(evt) {
  if (!storages || storages.length == 0) return;
  if (currentTarget == evt.target) return;
  $id('refresh').dataset.disabled = 'false';

  currentTarget = evt.target;
  loadingFiles();
}

function loadingFiles() {
  select(currentTarget);
  $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');

  var type = currentTarget.dataset.type;
  var loaded = type + 'Loaded';

  if (!storages || storages.length == 0)
  {
    showFiles(type);
    return;
  }

  if (filesContainer[loaded]) {
    showFiles(type);
    return;
  }
  searchFiles(type);
}

function searchFiles(type) {
  loading();
  // filter all files in trash
  // var trashReg = new RegExp('^/sdcard/\\.Trash-\d*');
  // filter all hidden files
  var loaded = type + 'Loaded';
  filesContainer[type] = [];
  if (!storages || storages.length == 0)
  {
    showFiles(type);
    return;
  }
  filesContainer[loaded] = false;
  for (var i=0; i<storages.length; i++) {
    searchStorage(storages[i], type);
  }
}

function searchStorage(storage, type) {
  var loaded = type + 'Loaded';
  var reg = new RegExp(type + '$');
  var hiddenReg = new RegExp('/\\.');
  var storagesContainer = {
    storageName: storage.storageName,
    storageFiles: []
  };
  var cursor = storage.enumerate('');
  cursor.onsuccess = function() {
    if (cursor.result == null) {
      filesContainer[type].push(storagesContainer);
      if(filesContainer[type].length == storages.length) {
        filesContainer[loaded] = true;
        showFiles(type);
      }
      return;
    }
    var file = cursor.result;
    if (file.name.match(reg) && !file.name.match(hiddenReg)) {
      storagesContainer['storageFiles'].push(file);
    }
    cursor.continue();
  };
  cursor.onerror = function() {
    filesContainer[type].push(storagesContainer);
    if(filesContainer[type].length == storages.length) {
      filesContainer[loaded] = true;
      showFiles(type);
    }
    return;
  };
}

function loading() {
  $id('modal-loading').classList.remove('hidden');
  if (bDisplayDoc) {
    $id('modal-loading').style.marginTop = 46 + 'px';
    $id('loading-container').style.marginTop = ($id('modal-loading').clientHeight/2 - 50 - 46) + 'px';
    return;
  }
  $id('modal-loading').style.marginTop = 0 + 'px';
  $id('loading-container').style.marginTop = ($id('modal-loading').clientHeight/2 - 50) + 'px';
}

function showFiles(type) {
  var container = $id('list-container');
  container.innerHTML = '';
  if (filesContainer[type].length == 0) {
    showEmptyList(type);
    $id('modal-loading').classList.add('hidden');
    return;
  }
  container.classList.remove('hidden');

  for (var i=0;i<filesContainer[type].length;i++){
    var files = filesContainer[type][i];
    if (type != 'history') {
      container.appendChild(createHeadItem(files['storageName']));
    }
    if (files['storageFiles'].length == 0)
      continue;
    for (var j = 0; j < files['storageFiles'].length; j++) {
      container.appendChild(createListItem(i, j, type));
    }
  }

  $id('modal-loading').classList.add('hidden');
  $id('empty-list').classList.add('hidden');
}

function createHeadItem(storageName) {
  var div = document.createElement('div');
  div.classList.add('row-header');
  div.dataset.storageName = storageName;
  var span = document.createElement('span');
  span.textContent = storageName;
  div.appendChild(span);
  return div;
}

function createListItem(index, storage, type) {
  var div = document.createElement('div');
  div.classList.add('row-fluid');
  div.classList.add('item');
  var iconDiv = document.createElement('div');
  iconDiv.classList.add('span2');
  iconDiv.classList.add('list-title');
  iconDiv.classList.add('doctype');
  if (type != 'history') {
    iconDiv.dataset.type = type;
  } else {
    var i = filesContainer[type][index]['storageFiles'][storage].name.lastIndexOf('.');
    iconDiv.dataset.type = filesContainer[type][index]['storageFiles'][storage].name.substr(i + 1);
  }
  div.appendChild(iconDiv);
  var infoDiv = document.createElement('div');
  infoDiv.classList.add('span10');
  var infoRowDiv = document.createElement('div');
  infoRowDiv.classList.add('row-fluid');
  var infoNameDiv = document.createElement('div');
  infoNameDiv.classList.add('name');
  infoNameDiv.classList.add('span12');
  infoNameDiv.innerHTML = extractFileName(filesContainer[type][index]['storageFiles'][storage].name);
  var infoDetailDiv = document.createElement('div');
  infoDetailDiv.classList.add('span12');
  infoDetailDiv.classList.add('detail');
  infoDetailDiv.innerHTML = formatDate(filesContainer[type][index]['storageFiles'][storage].lastModifiedDate) + '  ' + formatFileSize(filesContainer[type][index]['storageFiles'][storage].size);

  infoRowDiv.appendChild(infoNameDiv);
  infoRowDiv.appendChild(infoDetailDiv);
  infoDiv.appendChild(infoRowDiv);
  div.appendChild(iconDiv);
  div.appendChild(infoDiv);
  infoDiv.dataset.filePath = filesContainer[type][index]['storageFiles'][storage].name;
  infoDiv.dataset.storage = storage;
  infoDiv.dataset.index = index;
  infoDiv.dataset.type = type;
  infoDiv.onclick = function() {
    $id('file-action').classList.remove('hidden');
    $id('file-action-form').onsubmit=function() {
      return false;
    };
    $id('file-action').dataset.storage = this.dataset.storage;
    $id('file-action').dataset.index = this.dataset.index;
    $id('file-action').dataset.type = this.dataset.type;
    $id('file-action').dataset.filePath = this.dataset.filePath;
    $id('file-action-header').textContent = extractFileName(this.dataset.filePath);;
    $id('open-button').onclick = function() {
      $id('file-action').classList.add('hidden');
      loadFile($id('file-action').dataset.filePath);
    };
    $id('details-button').onclick = function() {
      $id('file-action').classList.add('hidden');
      showFileInfo();
    };
    $id('delete-button').onclick = function() {
      $id('file-action').classList.add('hidden');
      if (window.confirm(navigator.mozL10n.get('sure-delete') + $id('file-action-header').textContent + '?')) {
        deleteFile();
      }
    };
    $id('cancel-button').onclick = function() {
      $id('file-action').classList.add('hidden');
    };
  };

  div.onmousedown = div.ontouchstart = function() {
    this.classList.add('hover');
  };
  div.onmouseup = div.ontouchend = function() {
    this.classList.remove('hover');
  };

  return div;
}

function loadFile(filePath) {
  if (bItemLongPressed) return;
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('documentName').innerHTML = extractFileName(filePath);
  $id('container').classList.remove('hidden');
  bDisplayDoc = true;
  loading();
  var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + filePath +
               '" WIDTH=100% HEIGHT=100% FRAMEBORDER=0 scrolling="no" mozbrowser remote></IFRAME>';
  $id('file-display').innerHTML = iframe;
}

function refresh() {
  if (!storages || storages.length == 0 || !currentTarget || currentTarget.id == 'history') {
    return;
  }

  $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');
  loading();

  var type = currentTarget.dataset.type;
  var loaded = type + 'Loaded';
  searchFiles(type);
}

function select(target) {
  $id('history').classList.remove('selected');
  $id('docx').classList.remove('selected');
  $id('xlsx').classList.remove('selected');
  $id('pptx').classList.remove('selected');
  $id(target.id).classList.add('selected');
}

function showEmptyList(type) {
  if (type == 'history') {
    $id('empty-list-header').innerHTML = navigator.mozL10n.get('no_recent_files_found');
    $id('empty-list-des').classList.add('hidden');
    $id('empty-list-button').classList.add('hidden');
  } else {
    $id('empty-list-header').innerHTML = navigator.mozL10n.get('files_not_found');
    $id('empty-list-des').classList.remove('hidden');
    $id('empty-list-button').classList.remove('hidden');
  }
  $id('list-container').classList.add('hidden');
  $id('empty-list').classList.remove('hidden');
}

function goBack() {
  $id('list-header').classList.remove('hidden');
  $id('list-container').classList.remove('hidden');
  $id('container').classList.add('hidden');
  $id('file-display').innerHTML = '';
}

function showFileInfo() {
  var storage = parseInt($id('file-action').dataset.storage);
  var index = parseInt($id('file-action').dataset.index);
  var type = $id('file-action').dataset.type;
  var filePath = $id('file-action').dataset.filePath;
  var file = filesContainer[type][index]['storageFiles'][storage];
  $id('absolute-path').textContent = file.name;
  $id('file-size').textContent = formatFileSize(file.size);
  $id('file-name').textContent = extractFileName(file.name);
  $id('file-modified').textContent = formatDate(file.lastModifiedDate);
  $id('file-action').classList.add('hidden');
  $id('details').classList.remove('hidden');
  $id('close-button').onclick = function() {
    $id('details').classList.add('hidden');
  };
}

function deleteFile() {
  var storage = parseInt($id('file-action').dataset.storage);
  var index = parseInt($id('file-action').dataset.index);
  var type = $id('file-action').dataset.type;
  for (var i=0; i<storages.length; i++) {
    if (storages[i].storageName != filesContainer[type][index].storageName) {
      continue;
    }
    var req =  storages[i].delete(filesContainer[type][index]['storageFiles'][storage].name);
    req.onsuccess = function() {
      var container = $id('list-container');
      var items = container.querySelectorAll('.item');
      for (var i = 0; i < items.length; i++) {
        if (items[i].lastChild.dataset.index == index && items[i].lastChild.dataset.storage == storage) {
          container.removeChild(items[i]);
          break;
        }
      }
    };
    req.onerror = function(e) {
      console.log('delete file failed:' + e.name);
    };
    return;
  }
}

function showHistory(evt) {
  $id('refresh').dataset.disabled = 'true';
  if (!db) return;
  if (currentTarget == evt.target) return;

  currentTarget = evt.target;
  select(currentTarget);

  var container = $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');

  loading();
  updateHistory();
}

function updateHistory() {
  if (!db) return;

  filesContainer.history = [];
  var count = 0;
  var tx = db.transaction(["files"], "readwrite");
  var store = tx.objectStore("files");
  var index = store.index('lastAccessDate');
  var storagesContainer = {
    storageName: 'history',
    storageFiles: []
  };
  filesContainer.history.push(storagesContainer);
  index.openCursor(null, 'prev').onsuccess = function(event) {
    var cursor = event.target.result;
    if (!cursor || count >= MAX_COUNT) {
      showFiles('history');
      return;
    }
    count++;
    filesContainer.history[0].storageFiles.push({
      name: cursor.value.name,
      size: cursor.value.size,
      lastModifiedDate: cursor.value.lastModifiedDate
    });
    cursor.continue();
  };
}

function swipe(evt) {
  switch (evt.detail.direction) {
    case 'right':
      switch (currentTarget.id) {
        case 'docx':
          if (!db) return;
          currentTarget = $id('history');
          $id('refresh').dataset.disabled = 'true';

          select(currentTarget);
          var container = $id('list-container').innerHTML = '';
          $id('empty-list').classList.add('hidden');

          loading();
          updateHistory();
          return;
        case 'xlsx':
          currentTarget = $id('docx');
          loadingFiles();
          break;
        case 'pptx':
          currentTarget = $id('xlsx');
          loadingFiles();
          break;
      }
      break;
    case 'left':
      switch (currentTarget.id) {
        case 'history':
          currentTarget = $id('docx');
          loadingFiles();
          break;
        case 'docx':
          currentTarget = $id('xlsx');
          loadingFiles();
          break;
        case 'xlsx':
          currentTarget = $id('pptx');
          loadingFiles();
          break;
      }
      break;
  }
  if (storages && storages.length > 0)
    $id('refresh').dataset.disabled = 'false';
  console.log('swipe:' + evt.detail.direction);
}

function init() {
  storages = navigator.getDeviceStorages("sdcard");
  if (!storages) {
    var storage = navigator.getDeviceStorage("sdcard");
    if (storage) {
      storages.push(storage);
    }
  }

  $id("history").onclick = showHistory;
  $id('docx').onclick = loadFiles;
  $id('xlsx').onclick = loadFiles;
  $id('pptx').onclick = loadFiles;
  $id('refresh').onclick = $id('empty-list-button').onclick = refresh;

  $id("history").onmousedown = $id("history").ontouchstart =
  $id("docx").onmousedown = $id("docx").ontouchstart =
  $id("xlsx").onmousedown = $id("xlsx").ontouchstart =
  $id("pptx").onmousedown = $id("pptx").ontouchstart = function() {
    this.classList.add('hover');
  };
  $id("history").onmouseup = $id("history").ontouchend =
  $id("docx").onmouseup = $id("docx").ontouchend =
  $id("xlsx").onmouseup = $id("xlsx").ontouchend =
  $id("pptx").onmouseup = $id("pptx").ontouchend = function() {
    this.classList.remove('hover');
  };
  document.getElementById('empty-list-refresh').onmousedown = document.getElementById('empty-list-refresh').ontouchstart =
  $id("refresh").onmousedown = $id("refresh").ontouchstart =
  $id("quitViewer").onmousedown = $id("quitViewer").ontouchstart = function() {
    this.classList.add('touchover');
  };
  document.getElementById('empty-list-refresh').onmouseup = document.getElementById('empty-list-refresh').ontouchend =
  $id("refresh").onmouseup = $id("refresh").ontouchend =
  $id("quitViewer").onmouseup = $id("quitViewer").ontouchend = function() {
    this.classList.remove('touchover');
  };

  $id('quitViewer').onclick = function() {
    bDisplayDoc = false;
    screen.mozUnlockOrientation();
    $id('pages').classList.add('hidden');
    $id('modal-loading').classList.add('hidden');
    $id('list-header').classList.remove('hidden');
    $id('list-container').classList.remove('hidden');
    $id('container').classList.add('hidden');
    $id('file-display').innerHTML = '';
    if (currentTarget.id == 'history') {
      loading();
      updateHistory();
    }
  };
  window.onresize = function() {
    if (bDisplayDoc) {
      $id('modal-loading').style.marginTop = 46 + 'px';
      $id('loading-container').style.marginTop = ($id('modal-loading').clientHeight/2 - 50 - 46) + 'px';
    } else {
      $id('modal-loading').style.marginTop = 0 + 'px';
      $id('loading-container').style.marginTop = ($id('modal-loading').clientHeight/2 - 50) + 'px';
    }
    $id('file-ops-container').style.marginTop = ($id('file-action').clientHeight/2 - 50) + 'px';
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

  var gd = new GestureDetector($id('list-container'), {holdEvents:true, panThreshold:5, mousePanThreshold:5});
  var gd2 = new GestureDetector($id('empty-list'), {holdEvents:true, panThreshold:5, mousePanThreshold:5});
  gd.startDetecting();
  gd2.startDetecting();

  $id('list-container').addEventListener('tap', function(evt) {
    console.log('tap');
  });
  $id('list-container').addEventListener('swipe', swipe);
  $id('empty-list').addEventListener('swipe', swipe);
  $id('list-container').addEventListener('pan', function(evt) {
    console.log('pan');
    bTouchMoved = true;
  });
  $id('docx').click();
}

window.addEventListener("load", init, false);
