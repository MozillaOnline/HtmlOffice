$(document).ready(function(){
    $('#button_info_asd_show').click(function(){
         $('#info_asd').show();
         $('#button_info_asd_show').hide();
         $('#button_info_asd_hide').show();
    });
    $('#button_info_asd_hide').click(function(){
         $('#info_asd').hide();
         $('#button_info_asd_show').show();
         $('#button_info_asd_hide').hide();
    });
    window.navigator.mozSetMessageHandler('activity', function(activity) {
        var url = activity.source.data.url;
        $('#iframe_url').attr('src',url);
        var cancelButton = document.getElementById('activityClose');
        cancelButton.addEventListener('click', function() {
          activity.postResult('close');
        });
    });
});