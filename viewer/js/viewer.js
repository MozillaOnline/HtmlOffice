function Viewer(viewerPlugin) {
    "use strict";

    var self = this,
        kScrollbarPadding = 40,
        kMinScale = 0.4,
        kMaxScale = 1.0,
        kDefaultScaleDelta = 1.1,
        isSlideshow = false,
        url,
        viewerElement = document.getElementById('viewer'),
        canvasContainer = document.getElementById('canvasContainer'),
        overlayNavigator = document.getElementById('overlayNavigator'),
        showZoomPanelTimer = null,
        bZoomPanelShowed = false,
        fileLoaded = false,
        pages = [],
        currentPage;

  this.showPage = function (n) {
    if (n <= 0) {
      n = 1;
    } else if (n > pages.length) {
      n = pages.length;
    }

    viewerPlugin.showPage(n);
    currentPage = n;
    parent.document.getElementById('pages').innerHTML = n + '/' + pages.length;
  };

  this.showNextPage = function () {
    self.showPage(currentPage + 1);
  };

  this.showPreviousPage = function () {
    self.showPage(currentPage - 1);
  };

  this.initialize = function () {
    var location = String(document.location),
    pos = location.indexOf('#'),

    location = location.substr(pos + 1);
    location = decodeURIComponent(location)
    var storage = navigator.getDeviceStorage('sdcard');
    var pdf_file = storage.get(location);

    pdf_file.onerror = function() {
      document.getElementById('loadingFailed').classList.remove('hidden');
      document.getElementById('dimmer').style.display = 'none';
      parent.document.getElementById('modal-loading').classList.add('hidden');
      console.error("Error in: ", pdf_file.error.name);
    };
    pdf_file.onsuccess = function(event) {
      var file = pdf_file.result;
      try {
        convertoox2odf(file, function(content) {
          document.getElementById('failed-reason').innerHTML = navigator.mozL10n.get('loading_failed');
          document.getElementById('choose-file').innerHTML = navigator.mozL10n.get('choose_another_file');
          document.getElementById('return').innerHTML = navigator.mozL10n.get('return');
          document.getElementById('full-width').innerHTML = navigator.mozL10n.get('full-width');
          document.getElementById('actual-size').innerHTML = navigator.mozL10n.get('actual-size');
          if (content == 'FILE_IS_TOO_BIG') {
            document.getElementById('failed-reason').innerHTML = navigator.mozL10n.get('file-is-too-big');
            document.getElementById('loadingFailed').classList.remove('hidden');
            document.getElementById('dimmer').style.display = 'none';
            parent.document.getElementById('modal-loading').classList.add('hidden');
          } else if (content) {
            var url = {type: 4, files: content};

            viewerPlugin.onLoad = function () {
              isSlideshow = viewerPlugin.isSlideshow();
              if (isSlideshow) {
                overlayNavigator.style.display = 'block';
                parent.document.getElementById('pages').classList.remove('hidden');
              } else {
                parent.document.getElementById('pages').classList.add('hidden');
              }
              pages = viewerPlugin.getPages();
              self.showPage(1);
              parent.document.getElementById('pages').innerHTML = 1 + '/' + pages.length;
              document.getElementById('zoom-size-selector').selectedIndex = 0;
              fileLoaded = true;
              var widthZoomLevel = Math.min(canvasContainer.clientWidth, canvasContainer.clientHeight) * viewerPlugin.getZoomLevel() / viewerPlugin.getElement().offsetWidth;
              kMinScale = Math.min(widthZoomLevel, 1.0);
              kMaxScale = Math.max(widthZoomLevel, 1.0);
              setScale(kMinScale);
              document.getElementById('loadingFailed').classList.add('hidden');
              document.getElementById('dimmer').style.display = 'block';
              parent.document.getElementById('modal-loading').classList.add('hidden');
              document.getElementById('scale').classList.remove('hidden');
              bZoomPanelShowed = true;
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
            document.getElementById('dimmer').style.display = 'none';
            parent.document.getElementById('modal-loading').classList.add('hidden');
          }
        });
      } catch (e) {
        document.getElementById('loadingFailed').classList.remove('hidden');
        document.getElementById('dimmer').style.display = 'block';
        parent.document.getElementById('modal-loading').classList.add('hidden');
      }
    };
  };

  function zoomIn() {
    var zoomLevel = viewerPlugin.getZoomLevel();
    var newScale = (zoomLevel * kDefaultScaleDelta).toFixed(2);
    if (newScale > kMinScale && newScale < kMaxScale) {
      document.getElementById('zoom-size-selector').selectedIndex = 2;
      document.getElementById('zoom-size-customor').textContent = Math.round(newScale * 100) + '%';
    } else if (newScale <= kMinScale) {
      newScale = kMinScale;
      document.getElementById('zoom-size-selector').selectedIndex = 0;
    } else {
      newScale = kMaxScale;
      document.getElementById('zoom-size-selector').selectedIndex = 1;
    }
    setScale(newScale);
  }

  function zoomOut() {
    var zoomLevel = viewerPlugin.getZoomLevel();
    var newScale = (zoomLevel / kDefaultScaleDelta).toFixed(2);
    if (newScale > kMinScale && newScale < kMaxScale) {
      document.getElementById('zoom-size-selector').selectedIndex = 2;
      document.getElementById('zoom-size-customor').textContent = Math.round(newScale * 100) + '%';
    } else if (newScale <= kMinScale) {
      newScale = kMinScale;
      document.getElementById('zoom-size-selector').selectedIndex = 0;
    } else {
      newScale = kMaxScale;
      document.getElementById('zoom-size-selector').selectedIndex = 1;
    }
    setScale(newScale);
  }

  function goBack() {
    parent.document.getElementById('list-header').classList.remove('hidden');
    parent.document.getElementById('list-container').classList.remove('hidden');
    parent.document.getElementById('container').classList.add('hidden');
    parent.document.getElementById('file-display').innerHTML = '';
  }

  function setScale(value) {
    if (value === viewerPlugin.getZoomLevel()) {
      return;
    }
    viewerPlugin.setZoomLevel(value);
  }

  function init() {
    if (viewerPlugin) {
      self.initialize();
    }

    viewerElement.onclick = function(evt) {
      if (evt.target.id == 'previousPage') {
        self.showPreviousPage();
        return;
      }
      if (evt.target.id == 'nextPage') {
        self.showNextPage();
        return;
      }
      if (fileLoaded) {
        if (bZoomPanelShowed) {
          document.getElementById('scale').classList.add('hidden');
          bZoomPanelShowed = false;
        } else {
          document.getElementById('scale').classList.remove('hidden');
          bZoomPanelShowed = true;
        }
      } else {
        if (evt.target.id == 'empty-list-return') {
          goBack();
        }
      }
    }
    document.getElementById('empty-list-return').onmousedown = document.getElementById('empty-list-return').ontouchstart =
    document.getElementById('zoom-out').onmousedown = document.getElementById('zoom-out').ontouchstart =
    document.getElementById('zoom-in').onmousedown = document.getElementById('zoom-in').ontouchstart = function() {
      this.classList.add('touchover');
    };
    document.getElementById('empty-list-return').onmouseup = document.getElementById('empty-list-return').ontouchend =
    document.getElementById('zoom-out').onmouseup = document.getElementById('zoom-out').ontouchend =
    document.getElementById('zoom-in').onmouseup = document.getElementById('zoom-in').ontouchend = function() {
      this.classList.remove('touchover');
    };
    document.getElementById('empty-list-return').onclick = goBack;

    document.getElementById('zoom-size-selector').addEventListener('change', function (evt) {
      var settingItem = evt.target;
      switch (settingItem.value) {
        case '0':
            setScale(kMinScale);
            break;
        case '1':
            setScale(kMaxScale);
            break;
        case '2':
            var zoomSize = document.getElementById('zoom-size-customor').textContent;
            setScale(parseInt(zoomSize) / 100);
            break;
      }

    });
    document.getElementById('zoom-in').onclick = zoomIn;
    document.getElementById('zoom-out').onclick = zoomOut;
    window.addEventListener('resize', function (evt) {
      console.log('resize');
      /*if (isSlideshow) {
        parent.window.screen.mozLockOrientation('landscape');
      }*/
    });
  }

  init();
}
