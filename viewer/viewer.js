function Viewer(viewerPlugin) {
    "use strict";

    var self = this,
        kScrollbarPadding = 40,
        kMinScale = 0.25,
        kMaxScale = 4.0,
        kDefaultScaleDelta = 1.1,
        kDefaultScale = 'auto',
        presentationMode = false,
        initialized = false,
        isSlideshow = false,
        url,
        viewerElement = document.getElementById('viewer'),
        canvasContainer = document.getElementById('canvasContainer'),
        overlayNavigator = document.getElementById('overlayNavigator'),
        pageSwitcher = document.getElementById('toolbarLeft'),
        zoomWidget = document.getElementById('toolbarMiddleContainer'),
        scaleSelector = document.getElementById('scaleSelect'),
        overlay = document.getElementById('overlay'),
        //toolbarRight = document.getElementById('toolbarRight'),
        //aboutDialog,
        filename,
        pages = [],
        currentPage,
        scaleChangeTimer,
        touchTimer;
/*
    function initializeAboutInformation() {
        var basedOnDiv, aboutButton, pluginName, pluginVersion, pluginURL;

        if (viewerPlugin) {
            pluginName = viewerPlugin.getPluginName();
            pluginVersion = viewerPlugin.getPluginVersion();
            pluginURL = viewerPlugin.getPluginURL();
        }

        // Create dialog
        aboutDialog = document.createElement('div');
        aboutDialog.id = "aboutDialog";
        aboutDialog.innerHTML =
            "<h1><a href = \"http://viewerjs.org\" target=\"_blank\">ViewerJS</a></h1>" +
            "<p><a href = \"http://nlnet.nl\" target=\"_blank\"><img src=\"images\/nlnet.png\" width=\"160\" height=\"60\"></img></a></p>" +
            "<p><a href = \"http://kogmbh.com\" target=\"_blank\"><img src=\"images\/kogmbh.png\" width=\"172\" height=\"40\"></img></a></p>" +
            (viewerPlugin ? ("<p>Using the <a href = \""+ pluginURL + "\" target=\"_blank\">" + pluginName + "</a> " +
                            "(<span id = \"pluginVersion\">" + pluginVersion + "</span>) " +
                            "plugin to show you this document.</p>")
                         : "") +
            "<p>Made by <a href = \"http://kogmbh.com\" target=\"_blank\">KO GmbH</a>.</p>" +
            "<button id = \"aboutDialogCloseButton\" class = \"toolbarButton textButton\">Close</button>";
        viewerElement.appendChild(aboutDialog);

        document.getElementById('aboutDialogCloseButton').addEventListener('click', function () {
                hideAboutDialog();
        });

    }

    function showAboutDialog() {
        aboutDialog.style.display = 'block';
        overlay.style.visibility = "visible";
    }

    function hideAboutDialog() {
        aboutDialog.style.display = "none";
        overlay.style.visibility = "hidden";
    }

    function isFullScreen() {
    // Note that the browser fullscreen (triggered by short keys) might
    // be considered different from content fullscreen when expecting a boolean
        return document.isFullScreen || document.mozFullScreen || document.webkitIsFullScreen;
    }
*/
    function selectScaleOption(value) {
        // Retrieve the options from the zoom level <select> element
        var options = scaleSelector.options,
            option,
            predefinedValueFound = false,
            i;

        for (i = 0; i < options.length; i += 1) {
            option = options[i];
            if (option.value !== value) {
                option.selected = false;
                continue;
            }
            option.selected = true;
            predefinedValueFound = true;
        }
        return predefinedValueFound;
    }

    function getPages() {
        return viewerPlugin.getPages();
    }

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

    function onScroll() {
        var pageNumber;

        if (viewerPlugin.onScroll) {
            viewerPlugin.onScroll();
        }
        if (viewerPlugin.getPageInView) {
            pageNumber = viewerPlugin.getPageInView();
            if (pageNumber) {
                currentPage = pageNumber;
                document.getElementById('pageNumber').value = pageNumber;
            }
        }
    }

    function delayedRefresh(milliseconds) {
        window.clearTimeout(scaleChangeTimer);
        scaleChangeTimer = window.setTimeout(function () {
            onScroll();
        }, milliseconds);
    }

    function parseScale(value, resetAutoSettings, noScroll) {
        var scale,
            maxWidth,
            maxHeight;

        if (value === 'custom') {
            scale = parseFloat(document.getElementById('customScaleOption').textContent) / 100;
        } else {
            scale = parseFloat(value);
        }

        if (scale) {
            setScale(scale, true, noScroll);
            delayedRefresh(300);
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

        selectScaleOption(value);
        delayedRefresh(300);
    }

    
    this.initialize = function () {
        var location = String(document.location),
            pos = location.indexOf('#'),
            element;

        location = location.substr(pos + 1);
        if (pos === -1 || location.length === 0) {
            console.log('Could not parse file path argument.');
            return;
        }
        location = decodeURIComponent(location)
        var storage = navigator.getDeviceStorage("sdcard");
            var pdf_file = storage.get(location);
            pdf_file.onerror = function() {
                console.error("Error in: ", pdf_file.error.name);
            };
            pdf_file.onsuccess = function(event) {
                var file = pdf_file.result;
				convertoox2odf(file, function(content) {
                var reader  = new FileReader();

                reader.onload = function () {
                    url = reader.result;
                    document.title = location;
                    var ultimo = document.title.split("/").pop();
                    var pdf = ultimo.charAt(0).toUpperCase() + ultimo.slice(1);
                    //document.getElementById('documentName').innerHTML = pdf;

                    viewerPlugin.onLoad = function () {
                        //document.getElementById('pluginVersion').innerHTML = viewerPlugin.getPluginVersion();

                        isSlideshow = viewerPlugin.isSlideshow();
                        if (isSlideshow) {
                            // No padding for slideshows
                            canvasContainer.style.padding = 0;
                            // Show page nav controls only for presentations
                            pageSwitcher.style.visibility = 'visible';
                        } else {
                            // For text documents, show the zoom widget.
                            zoomWidget.style.visibility = 'visible';
                            // Only show the page switcher widget if the plugin supports page numbers
                            if (viewerPlugin.getPageInView) {
                                pageSwitcher.style.visibility = 'visible';
                            }
                        }

                        initialized = true;
                        pages = getPages();
                        document.getElementById('numPages').innerHTML = 'of ' + pages.length;

                        self.showPage(1);

                        // Set default scale
                        parseScale(kDefaultScale);

                        canvasContainer.onscroll = onScroll;
                        delayedRefresh();
                    };

                    viewerPlugin.initialize(canvasContainer, url);
                }

                if (file) {
                   reader.readAsDataURL(content);
                }
            });
			};
    };

    /**
     * Shows the 'n'th page. If n is larger than the page count,
     * shows the last page. If n is less than 1, shows the first page.
     * @return {undefined}
     */
    this.showPage = function (n) {
        if (n <= 0) {
            n = 1;
        } else if (n > pages.length) {
            n = pages.length;
        }

        viewerPlugin.showPage(n);

        currentPage = n;
        document.getElementById('pageNumber').value = currentPage;
    };

    /**
     * Shows the next page. If there is no subsequent page, does nothing.
     * @return {undefined}
     */
    this.showNextPage = function () {
        self.showPage(currentPage + 1);
    };

    /**
     * Shows the previous page. If there is no previous page, does nothing.
     * @return {undefined}
     */
    this.showPreviousPage = function () {
        self.showPage(currentPage - 1);
    };

    /**
     * Attempts to 'download' the file.
     * @return {undefined}
     */
/*
	 this.download = function () {
        var documentUrl = url.split('#')[0];
        documentUrl += '#viewer.action=download';
        window.open(documentUrl, '_parent');
    };
*/
    /**
     * Toggles the fullscreen state of the viewer
     * @return {undefined}
     */
	 /*
    this.toggleFullScreen = function () {
        var elem = viewerElement;
        if (!isFullScreen()) {
            if (elem.requestFullScreen) {
                elem.requestFullScreen();
            } else if (elem.mozRequestFullScreen) {
                elem.mozRequestFullScreen();
            } else if (elem.webkitRequestFullScreen) {
                elem.webkitRequestFullScreen();
            }
        } else {
            if (document.cancelFullScreen) {
                document.cancelFullScreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
            }
        }
    };
	*/
 
    /**
     * Toggles the presentation mode of the viewer.
     * Presentation mode involves fullscreen + hidden UI controls
     */
/*
	 this.togglePresentationMode = function () {
        var titlebar = document.getElementById('titlebar'),
            toolbar = document.getElementById('toolbarContainer'),
            overlayCloseButton = document.getElementById('overlayCloseButton');

        if (!presentationMode) {
            titlebar.style.display = toolbar.style.display = 'none';
            overlayCloseButton.style.display = 'block';
            canvasContainer.className = 'presentationMode';
            isSlideshow = true;
            canvasContainer.onmousedown = function (event) {
                event.preventDefault();
            };
            canvasContainer.oncontextmenu = function (event) {
                event.preventDefault();
            };
            canvasContainer.onmouseup = function (event) {
                event.preventDefault();
                if (event.which === 1) {
                    self.showNextPage();
                } else {
                    self.showPreviousPage();
                }
            };
            parseScale('page-fit');
        } else {
            titlebar.style.display = toolbar.style.display = 'block';
            overlayCloseButton.style.display = 'none';
            canvasContainer.className = '';
            canvasContainer.onmouseup = function () {};
            canvasContainer.oncontextmenu = function () {};
            canvasContainer.onmousedown = function () {};
            parseScale('auto');
            isSlideshow = viewerPlugin.isSlideshow();
        }

        presentationMode = !presentationMode;
    };
	*/

    /**
     * Gets the zoom level of the document
     * @return {!number}
     */
    this.getZoomLevel = function () {
        return viewerPlugin.getZoomLevel();
    };

    /**
     * Set the zoom level of the document
     * @param {!number} value
     * @return {undefined}
     */
    this.setZoomLevel = function (value) {
        viewerPlugin.setZoomLevel(value);
    };

    /**
     * Zoom out by 10 %
     * @return {undefined}
     */
    this.zoomOut = function () {
        // 10 % decrement
        var newScale = (self.getZoomLevel() / kDefaultScaleDelta).toFixed(2);
        newScale = Math.max(kMinScale, newScale);
        parseScale(newScale, true);
    };

    /**
     * Zoom in by 10%
     * @return {undefined}
     */
    this.zoomIn = function () {
        // 10 % increment
        var newScale = (self.getZoomLevel() * kDefaultScaleDelta).toFixed(2);
        newScale = Math.min(kMaxScale, newScale);
        parseScale(newScale, true);
    };
/*
    function cancelPresentationMode() {
        if (presentationMode && !isFullScreen()) {
            self.togglePresentationMode();
        }
    }
	*/

    function showOverlayNavigator() {
        if (isSlideshow) {
            overlayNavigator.className = 'touched';
            window.clearTimeout(touchTimer);
            touchTimer = window.setTimeout(function () {
                overlayNavigator.className = '';
            }, 2000);
        }
    }

    function init() {

        //initializeAboutInformation();

        if (viewerPlugin) {
            self.initialize();
/*
            if (!(document.cancelFullScreen || document.mozCancelFullScreen || document.webkitCancelFullScreen)) {
                document.getElementById('fullscreen').style.visibility = 'hidden';
            }
*/
//            document.getElementById('overlayCloseButton').addEventListener('click', self.toggleFullScreen);
//            document.getElementById('fullscreen').addEventListener('click', self.toggleFullScreen);
//            document.getElementById('presentation').addEventListener('click', function () {
//                if (!isFullScreen()) {
//                    self.toggleFullScreen();
//                }
//                self.togglePresentationMode();
//            });

//            document.addEventListener('fullscreenchange', cancelPresentationMode);
//            document.addEventListener('webkitfullscreenchange', cancelPresentationMode);
//            document.addEventListener('mozfullscreenchange', cancelPresentationMode);

//            document.getElementById('download').addEventListener('click', function () {
//                self.download();
//            });

            document.getElementById('zoomOut').addEventListener('click', function () {
                self.zoomOut();
            });

            document.getElementById('zoomIn').addEventListener('click', function () {
                self.zoomIn();
            });

            document.getElementById('previous').addEventListener('click', function () {
                self.showPreviousPage();
            });

            document.getElementById('next').addEventListener('click', function () {
                self.showNextPage();
            });

            document.getElementById('previousPage').addEventListener('click', function () {
                self.showPreviousPage();
            });

            document.getElementById('nextPage').addEventListener('click', function () {
                self.showNextPage();
            });

            document.getElementById('pageNumber').addEventListener('change', function () {
                self.showPage(this.value);
            });

            document.getElementById('scaleSelect').addEventListener('change', function () {
                parseScale(this.value);
            });

            canvasContainer.addEventListener('click', showOverlayNavigator);
            overlayNavigator.addEventListener('click', showOverlayNavigator);

            window.addEventListener('scalechange', function (evt) {
                var customScaleOption = document.getElementById('customScaleOption'),
                    predefinedValueFound = selectScaleOption(String(evt.scale));

                customScaleOption.selected = false;

                if (!predefinedValueFound) {
                    customScaleOption.textContent = Math.round(evt.scale * 10000) / 100 + '%';
                    customScaleOption.selected = true;
                }
            }, true);
/*
            window.addEventListener('resize', function (evt) {
                if (initialized &&
                          (document.getElementById('pageWidthOption').selected ||
                          document.getElementById('pageAutoOption').selected)) {
                    parseScale(document.getElementById('scaleSelect').value);
                }
                showOverlayNavigator();
            });

            window.addEventListener('keydown', function (evt) {
                var key = evt.keyCode,
                    shiftKey = evt.shiftKey;

                switch (key) {
                case 33: // pageUp
                case 38: // up
                case 37: // left
                    self.showPreviousPage();
                    break;
                case 34: // pageDown
                case 40: // down
                case 39: // right
                    self.showNextPage();
                    break;
                case 32: // space
                    shiftKey ? self.showPreviousPage() : self.showNextPage();
                    break;
                }
            });*/
        }
    }

    init();
}
