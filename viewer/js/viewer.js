function Viewer(viewerPlugin) {
    "use strict";

    var self = this,
        kScrollbarPadding = 40,
        kMinScale = 0.25,
        kMaxScale = 4.0,
        kDefaultScaleDelta = 1.1,
        kDefaultScale = 'auto',
        url,
        viewerElement = document.getElementById('viewer'),
        canvasContainer = document.getElementById('canvasContainer'),
        filename,
        scaleChangeTimer,
        // file,
        currentFontSize = 14,
        showZoomPanelTimer = null,
        hideZoomPanelTimer = null,
        loadingTimer = null;
        /*
        document.getElementById('test').onclick = function() {
          file = document.getElementById('input').files[0];
          init();
        };
        */


    function setScale(val, resetAutoSettings, noScroll) {
        if (val === self.getZoomLevel()) {
            return;
        }

        self.setZoomLevel(val);

        var event = document.createEvent('UIEvents');
        event.initUIEvent('scalechange', false, false, window, 0);
        event.scale = val;
        event.resetAutoSettings = resetAutoSettings;
        window.dispatchEvent(event);
    }


    function parseScale(value, resetAutoSettings, noScroll) {
        var scale,
            maxWidth,
            maxHeight;

            scale = parseFloat(value);

        if (scale) {
            setScale(scale, true, noScroll);
            return;
        }

        maxWidth = canvasContainer.clientWidth - kScrollbarPadding;
        maxHeight = canvasContainer.clientHeight - kScrollbarPadding;

        switch (value) {
        case 'page-actual':
            setScale(1, resetAutoSettings, noScroll);
            break;
        case 'page-width':
            viewerPlugin.fitToWidth(maxWidth);
            break;
        case 'page-height':
            viewerPlugin.fitToHeight(maxHeight);
            break;
        case 'page-fit':
            viewerPlugin.fitToPage(maxWidth, maxHeight);
            break;
        case 'auto':
            if (viewerPlugin.isSlideshow()) {
                viewerPlugin.fitToPage(maxWidth + kScrollbarPadding, maxHeight + kScrollbarPadding);
            } else {
                viewerPlugin.fitSmart(maxWidth);
            }
            break;
        }
    }


  this.initialize = function () {
    var location = String(document.location),
    pos = location.indexOf('#'),

    location = location.substr(pos + 1);
    location = decodeURIComponent(location)
    var storage = navigator.getDeviceStorage('sdcard');
    var pdf_file = storage.get(location);
    pdf_file.onerror = function() {
      document.getElementById('loadingFailed').classList.remove('hidden');
      parent.document.getElementById('modal-loading').classList.add('hidden');
      parent.loaded = true;
      console.error("Error in: ", pdf_file.error.name);
    };
    pdf_file.onsuccess = function(event) {
      var file = pdf_file.result;
      try {
        convertoox2odf(file, function(content) {
          if (content) {
            var url = {type: 4, files: content};
            document.title = location;
            var ultimo = document.title.split("/").pop();
            var pdf = ultimo.charAt(0).toUpperCase() + ultimo.slice(1);
            //document.getElementById('documentName').innerHTML = pdf;

            viewerPlugin.onLoad = function () {
              parseScale(kDefaultScale);
              if (loadingTimer) {
                clearInterval(loadingTimer);
                loadingTimer = null;
              }
              //document.getElementById('modal-loading').classList.add('hidden');
              parent.loaded = true;
              parent.document.getElementById('modal-loading').classList.add('hidden');
              var container = document.getElementById('canvasContainer');
              if (container) {
                container.focus();
                container.onblur = container.focus;
              }

              var db = parent.db;
              if (!db) return;

              var obj = {
                name: file.name,
                size: file.size,
                lastModifiedDate: file.lastModifiedDate,
                lastAccessDate: Date.now()
              };

              var tx = db.transaction(["files"], "readwrite");
              tx.oncomplete = function(event) {
                console.log("addToIndexedDB transaction complete");
              };

              tx.onerror = function(event) {
                console.log("addToIndexedDB transaction failed");
              };

              var store = tx.objectStore("files");
              var req = store.get(file.name);

              req.onsuccess = function(event) {
                var data = event.target.result;
                if (data) {
                  data.lastAccessDate = Date.now();
                  var reqUpdate = store.put(data);
                  reqUpdate.onsuccess = function() {
                    console.log('entity update successfully');
                  };
                  reqUpdate.onerror = function() {
                    console.log('entity update failed');
                  };
                } else {
                  var reqAdd = store.add(obj);
                  reqAdd.onsuccess = function(event) {
                    console.log("addToIndexedDB added to object store successfully");
                  };
                  reqAdd.onerror = function(event) {
                    console.log("addToIndexedDB added to object store failed");
                  };
                }
              };
              req.onerror = function(event) {
                console.log("lookup file by name failed");
              };
            };

            viewerPlugin.initialize(canvasContainer, url);
          } else {
            document.getElementById('loadingFailed').classList.remove('hidden');
            parent.document.getElementById('modal-loading').classList.add('hidden');
            parent.loaded = true;
          }
        });
      } catch (e) {
        document.getElementById('loadingFailed').classList.remove('hidden');
        parent.document.getElementById('modal-loading').classList.add('hidden');
        parent.loaded = true;
      }
    };
  };

  function zoomIn() {
    var zoomLevel = viewerPlugin.getZoomLevel();
    var newScale = (zoomLevel * kDefaultScaleDelta).toFixed(2);
    newScale = Math.min(kMaxScale, newScale);
    viewerPlugin.setZoomLevel(newScale);
    hideZoomPanel();
  }

  function zoomOut() {
    var zoomLevel = viewerPlugin.getZoomLevel();
    var newScale = (zoomLevel / kDefaultScaleDelta).toFixed(2);
    newScale = Math.max(kMinScale, newScale);
    viewerPlugin.setZoomLevel(newScale);
    hideZoomPanel();
  }

  function hideZoomPanel() {
    if (hideZoomPanelTimer) {
      clearTimeout(hideZoomPanelTimer);
      hideZoomPanelTimer = null;
    }
    hideZoomPanelTimer = setTimeout(function() {
      document.getElementById('scale').classList.add('hidden');
      hideZoomPanelTimer = null;
    }, 3000);
  }

  function goBack() {
    parent.document.getElementById('list-header').classList.remove('hidden');
    parent.document.getElementById('list-container').classList.remove('hidden');
    parent.document.getElementById('container').classList.add('hidden');
    parent.document.getElementById('file-display').innerHTML = '';
  }

  function loading(baseUrl) {
    document.getElementById('modal-loading').classList.remove('hidden');
    var img = document.getElementById('loading-img');
    var index = 0;
    loadingTimer = setInterval(function() {
      index %= 24;
      img.src = baseUrl + index + '.png';
      index++;
    }, 100);
  }

  function init() {
    if (viewerPlugin) {
      self.initialize();
    }

    //document.getElementById('goback').onclick = goBack;
    document.getElementById('return').onclick = goBack;

    var canvas = document.getElementById('canvas');
    canvas.onmousedown = canvas.ontouchstart = function() {
      //showZoomPanelTimer = setTimeout(function() {
        document.getElementById('scale').classList.remove('hidden');
        hideZoomPanel();
      //}, 1000);
    };
    canvas.onmouseup = canvas.ontouchend = function() {
      if (showZoomPanelTimer) {
        clearTimeout(showZoomPanelTimer);
        showZoomPanelTimer = null;
      }
    };
    document.getElementById('zoom-in').onclick = zoomIn;
    document.getElementById('zoom-out').onclick = zoomOut;

    window.addEventListener('resize', function (evt) {
      parseScale(kDefaultScale);
      console.log('resize');
    });
  }

  //loading('images/loading/');
  init();
}
