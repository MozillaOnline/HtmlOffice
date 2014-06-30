
var db = null;
var storage = null;
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
  if (!storage) return;
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
  if (filesContainer[loaded]) {
    showFiles(type);
    return;
  }
  searchFiles(type);
  filesContainer[loaded] = true;
}

function searchFiles(type) {
  loading();
  filesContainer[type] = [];
  var reg = new RegExp(type + '$');
  // filter all files in trash
  // var trashReg = new RegExp('^/sdcard/\\.Trash-\d*');
  // filter all hidden files
  var hiddenReg = new RegExp('/\\.');
  var cursor = storage.enumerate('');
  cursor.onsuccess = function() {
    if (cursor.result == null) {
      showFiles(type);
      return;
    }
    if (cursor.result) {
      var file = cursor.result;
      if (file.name.match(reg) && !file.name.match(hiddenReg)) {
        filesContainer[type].push(file);
      }
      cursor.continue();
    }
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
  for (var i = 0; i < filesContainer[type].length; i++) {
    container.appendChild(createListItem(i, type));
  }
  $id('modal-loading').classList.add('hidden');
  $id('empty-list').classList.add('hidden');
}

function createListItem(index, type) {
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
    var i = filesContainer[type][index].name.lastIndexOf('.');
    iconDiv.dataset.type = filesContainer[type][index].name.substr(i + 1);
  }
  div.appendChild(iconDiv);
  var infoDiv = document.createElement('div');
  infoDiv.classList.add('span10');
  var infoRowDiv = document.createElement('div');
  infoRowDiv.classList.add('row-fluid');
  var infoNameDiv = document.createElement('div');
  infoNameDiv.classList.add('name');
  infoNameDiv.classList.add('span12');
  infoNameDiv.innerHTML = extractFileName(filesContainer[type][index].name);
  var infoDetailDiv = document.createElement('div');
  infoDetailDiv.classList.add('span12');
  infoDetailDiv.classList.add('detail');
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
      $id('deleteFileName').innerHTML = navigator.mozL10n.get('delete') + ' ' + extractFileName(filesContainer[type][self.dataset.index].name) + ' ?';
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
            deleteFile();
            return;
          }

          if ($id('delete-confirm').classList.contains('hidden')) {
            $id('modal-file-ops').classList.add('hidden');
          }
        };
      }, 500);
    }
  };
  div.onmousedown = div.ontouchstart = function() {
    this.classList.add('hover');
  };
  div.onmouseup = div.ontouchend = function() {
    this.classList.remove('hover');
  };

  return div;
}

function loadFile(event) {
  if (bItemLongPressed) return;
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('documentName').innerHTML = extractFileName(event.target.parentNode.parentNode.dataset.filePath);
  $id('container').classList.remove('hidden');
  bDisplayDoc = true;
  loading();
  var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + event.target.parentNode.parentNode.dataset.filePath +
               '" WIDTH=100% HEIGHT=100% FRAMEBORDER=0 scrolling="no" mozbrowser remote></IFRAME>';
  $id('file-display').innerHTML = iframe;
}

function refresh() {
  if (!storage || !currentTarget || currentTarget.id == 'history') {
    return;
  }

  $id('list-container').innerHTML = '';
  $id('empty-list').classList.add('hidden');
  loading();

  var type = currentTarget.dataset.type;
  var loaded = type + 'Loaded';
  searchFiles(type);
  filesContainer[loaded] = true;
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
  $id('file-info').classList.add('hidden');
  $id('container').classList.add('hidden');
  $id('file-display').innerHTML = '';
}

function showFileInfo() {
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('file-display').classList.add('hidden');

  var index = parseInt($id('modal-file-ops').dataset.index);
  var type = $id('modal-file-ops').dataset.type;

  $id('file-info').dataset.name = filesContainer[type][index].name;

  var file = filesContainer[type][index];
  $id('name').innerHTML = extractFileName(file.name);
  $id('size').innerHTML = formatFileSize(file.size);
  $id('dir').innerHTML = file.name;
  $id('lastModify').innerHTML = formatDate(file.lastModifiedDate);
  $id('file-info').classList.remove('hidden');
  $id('open').onclick = function() {
    bDisplayDoc = true;
    $id('file-info').classList.add('hidden');
    $id('list-header').classList.add('hidden');
    $id('list-container').classList.add('hidden');
    $id('documentName').innerHTML = extractFileName($id('file-info').dataset.name);
    $id('container').classList.remove('hidden');
    loading();
    var iframe = '<IFRAME id="iframe" src = "viewer/index.html#' + $id('file-info').dataset.name +
                 '" WIDTH=100% HEIGHT=100% FRAMEBORDER=0 scrolling="no" mozbrowser remote></IFRAME>';
    $id('file-display').innerHTML = iframe;
  };
}

function deleteFile() {
  var index = parseInt($id('modal-file-ops').dataset.index);
  var type = $id('modal-file-ops').dataset.type;
  var req =  storage.delete(filesContainer[type][index].name);
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
  index.openCursor(null, 'prev').onsuccess = function(event) {
    var cursor = event.target.result;
    if (!cursor || count >= MAX_COUNT) {
      showFiles('history');
      return;
    }
    count++;
    filesContainer.history.push({
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
          break;
        case 'xlsx':
          if (!storage) return;
          $id('refresh').dataset.disabled = 'false';
          currentTarget = $id('docx');
          loadingFiles();
          break;
        case 'pptx':
          if (!storage) return;
          $id('refresh').dataset.disabled = 'false';
          currentTarget = $id('xlsx');
          loadingFiles();
          break;
      }
      break;
    case 'left':
      switch (currentTarget.id) {
        case 'history':
          if (!storage) return;
          $id('refresh').dataset.disabled = 'false';
          currentTarget = $id('docx');
          loadingFiles();
          break;
        case 'docx':
          if (!storage) return;
          $id('refresh').dataset.disabled = 'false';
          currentTarget = $id('xlsx');
          loadingFiles();
          break;
        case 'xlsx':
          if (!storage) return;
          $id('refresh').dataset.disabled = 'false';
          currentTarget = $id('pptx');
          loadingFiles();
          break;
      }
      break;
  }
  console.log('swipe:' + evt.detail.direction);
}

function init() {
  storage = navigator.getDeviceStorage("sdcard");
  $id("history").onclick = showHistory;
  $id('docx').onclick = loadFiles;
  $id('xlsx').onclick = loadFiles;
  $id('pptx').onclick = loadFiles;
  $id('goback').onclick = goBack;
  $id('refresh').onclick = $id('empty-list-button').onclick = refresh;

  $id("history").onmousedown = $id("history").ontouchstart =
  $id("docx").onmousedown = $id("docx").ontouchstart =
  $id("xlsx").onmousedown = $id("xlsx").ontouchstart =
  $id("pptx").onmousedown = $id("pptx").ontouchstart =
  $id("fileInfo").onmousedown = $id("fileInfo").ontouchstart =
  $id("deleteFile").onmousedown = $id("deleteFile").ontouchstart =  function() {
    this.classList.add('hover');
  };
  $id("history").onmouseup = $id("history").ontouchend =
  $id("docx").onmouseup = $id("docx").ontouchend =
  $id("xlsx").onmouseup = $id("xlsx").ontouchend =
  $id("pptx").onmouseup = $id("pptx").ontouchend =
  $id("fileInfo").onmouseup = $id("fileInfo").ontouchend =
  $id("deleteFile").onmouseup = $id("deleteFile").ontouchend =  function() {
    this.classList.remove('hover');
  };
  document.getElementById('empty-list-open').onmousedown = document.getElementById('empty-list-open').ontouchstart =
  document.getElementById('empty-list-refresh').onmousedown = document.getElementById('empty-list-refresh').ontouchstart =
  $id("refresh").onmousedown = $id("refresh").ontouchstart =
  $id("goback").onmousedown = $id("goback").ontouchstart =
  $id("quitViewer").onmousedown = $id("quitViewer").ontouchstart = function() {
    this.classList.add('touchover');
  };
  document.getElementById('empty-list-open').onmouseup = document.getElementById('empty-list-open').ontouchend =
  document.getElementById('empty-list-refresh').onmouseup = document.getElementById('empty-list-refresh').ontouchend =
  $id("refresh").onmouseup = $id("refresh").ontouchend =
  $id("goback").onmouseup = $id("goback").ontouchend =
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
