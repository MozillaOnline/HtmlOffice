var scrollableContainer = document.getElementById('canvasContainer');
var g2p = new GrabToPan({
    element: scrollableContainer,         // required
    onActiveChanged: function(isActive) { // optional
        if (window.console) { // IE doesn't define console unless the devtools are open
            console.log('Grab-to-pan is ' + (isActive ? 'activated' : 'deactivated'));
        }
    }
});
g2p.activate();