
var storage = null;
var currentTarget = null;
var loadingTimer = null;
var currentFontSize = 14;
var showZoomPanelTimer = null;
var hideZoomPanelTimer = null;
var bItemLongPressed = false;
var files = [];

//var files = [{name: "/sdcard/test.docx", lastModifiedDate: new Date(), size: 100},
//             {name: "/sdcard/test2.docx", lastModifiedDate: new Date(), size: 200}];
//var files = [];

function loadFiles(e) {
  if (!storage) return;
  if (currentTarget == e.target) return;

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
    }
    showFiles();
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
  };
  return div;
}

function loadFile(event) {
  if (bItemLongPressed) return;
  console.log('loadFile');
  $id('list-header').classList.add('hidden');
  $id('list-container').classList.add('hidden');
  $id('file-container').classList.remove('hidden');
  // loading('images/loading2/');

  // $id('file-display').classList.add('hidden');
  // $id('loadingFailed').classList.remove('hidden');

  $id('file-display').classList.remove('hidden');
  $id('file-info').classList.add('hidden');

  try {
    var file = files[event.target.parentNode.parentNode.dataset.index];
    convertoox2odf(file, function(content) {
      var array = new ArrayBuffer(content.length);
      for (var i = 0; i < array.length; i++) {
        array[i] = str.at(i);
      }
    });
    unzipFile(file, function (zip) {
      var xmlfile = analysisDocx(zip.files);
      var sourcePzip = xslTransform(xmlfile, "../xsl/word/oox2odf/oox2odf.xsl");
      var base64zip = zipFile(sourcePzip, zip.files);
      var odfelement = $id('file-display');
      var odfcanvas = new odf.OdfCanvas(odfelement);
      // var blob = new Blob(, {type: ''});
      storage.addNamed(b64toBlob(base64zip, ''), 'tmp.odt');
      odfcanvas.load("tmp.odt");
    });
  } catch (e) {
    alert(e);
  }
  // $id('file-display').innerHTML = 'woujdoifuoisdfjiodfjodifjdfiodufioduoi';
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
  $id('file-container').classList.add('hidden');
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
  $id('file-container').classList.remove('hidden');
  $id('file-display').classList.add('hidden');
  $id('file-info').classList.remove('hidden');

}

function init() {
  storage = navigator.getDeviceStorage("sdcard");
  $id("recent").onclick = recent;
  $id('doc').onclick = loadFiles;
  $id('xls').onclick = loadFiles;
  $id('ppt').onclick = loadFiles;
  $id('goback').onclick = $id('return').onclick = goBack;
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
  $id('zoom-in').onclick = zoomIn;
  $id('zoom-out').onclick = zoomOut;
  $id('fileInfo').onclick = showFileInfo;
}

function b64toBlob(b64Data, contentType, sliceSize) {
    contentType = contentType || '';
    sliceSize = sliceSize || 512;

    var byteCharacters = b64Data;
    //var byteCharacters = atob(b64Data);
    var byteArrays = [];

    for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
        var slice = byteCharacters.slice(offset, offset + sliceSize);

        var byteNumbers = new Array(slice.length);
        for (var i = 0; i < slice.length; i++) {
            byteNumbers[i] = slice.charCodeAt(i);
        }

        var byteArray = new Uint8Array(byteNumbers);

        byteArrays.push(byteArray);
    }

    var blob = new Blob(byteArrays, {type: contentType});
    return blob;
}

window.addEventListener("load", init, false);
