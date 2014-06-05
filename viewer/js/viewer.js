function Viewer(viewerPlugin) {
    "use strict";

    var self = this,
        kScrollbarPadding = 40,
        kMinScale = 0.25,
        kMaxScale = 4.0,
        kDefaultScaleDelta = 1.1,
        kDefaultScale = 'page-width',
        url,
        viewerElement = document.getElementById('viewer'),
        canvasContainer = document.getElementById('canvasContainer'),
        showZoomPanelTimer = null,
        bZoomPanelShowed = false,
        hideZoomPanelTimer = null,
        fileLoaded = false;

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

        maxWidth = canvasContainer.clientWidth;// - kScrollbarPadding;
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
      console.error("Error in: ", pdf_file.error.name);
    };
    pdf_file.onsuccess = function(event) {
      var file = pdf_file.result;
      try {
        convertoox2odf(file, function(content) {
          if (content == 'FILE_IS_TOO_BIG') {
            document.getElementById('failed-reason').innerHTML = 'File is too big, load failed.';
            document.getElementById('loadingFailed').classList.remove('hidden');
            parent.document.getElementById('modal-loading').classList.add('hidden');
          }
          if (content) {
            var url = {type: 4, files: content};

            viewerPlugin.onLoad = function () {
              parseScale(kDefaultScale);
              fileLoaded = true;
              parent.document.getElementById('modal-loading').classList.add('hidden');

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
          }
          if (!content) {
            document.getElementById('loadingFailed').classList.remove('hidden');
            parent.document.getElementById('modal-loading').classList.add('hidden');
          }
        });
      } catch (e) {
        document.getElementById('loadingFailed').classList.remove('hidden');
        parent.document.getElementById('modal-loading').classList.add('hidden');
      }
    };
  };

  function zoomIn() {
    var zoomLevel = viewerPlugin.getZoomLevel();
    var newScale = (zoomLevel * kDefaultScaleDelta).toFixed(2);
    newScale = Math.min(kMaxScale, newScale);
    viewerPlugin.setZoomLevel(newScale);
  }

  function zoomOut() {
    var zoomLevel = viewerPlugin.getZoomLevel();
    var newScale = (zoomLevel / kDefaultScaleDelta).toFixed(2);
    newScale = Math.max(kMinScale, newScale);
    viewerPlugin.setZoomLevel(newScale);
  }

  function hideZoomPanel() {
    hideZoomPanelTimer = setTimeout(function() {
      document.getElementById('scale').classList.add('hidden');
      hideZoomPanelTimer = null;
    }, 20000);
  }

  function goBack() {
    parent.document.getElementById('list-header').classList.remove('hidden');
    parent.document.getElementById('list-container').classList.remove('hidden');
    parent.document.getElementById('container').classList.add('hidden');
    parent.document.getElementById('file-display').innerHTML = '';
  }

  function init() {
    if (viewerPlugin) {
      self.initialize();
    }

    var canvas = document.getElementById('canvas');
    viewerElement.onclick = function(evt) {
      if (evt.target.id == 'return') {
        goBack();
        return;
      }
      if (!fileLoaded) return;
      if (bZoomPanelShowed) {
        document.getElementById('scale').classList.add('hidden');
        if (hideZoomPanelTimer) {
          clearTimeout(hideZoomPanelTimer);
          hideZoomPanelTimer = null;
        }
        bZoomPanelShowed = false;
        return;
      }
      document.getElementById('scale').classList.remove('hidden');
      bZoomPanelShowed = true;
      hideZoomPanel();
    };
    document.getElementById('zoom-in').onclick = zoomIn;
    document.getElementById('zoom-out').onclick = zoomOut;

    window.addEventListener('resize', function (evt) {
      parseScale(kDefaultScale);
      console.log('resize');
    });
  }

  init();
}
