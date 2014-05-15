$(document).ready(function(){
    window.navigator.mozSetMessageHandler('activity', function(activity) {
        var url = activity.source.data.url;
        $('#iframe_url').attr('src',url);
        var cancelButton = document.getElementById('activityClose');
        cancelButton.addEventListener('click', function() {
          activity.postResult('close');
        });
        $('#iframe_url').load(function(){
        	$('.ui.active.inline.loader').parent().hide()
        });
    });
});