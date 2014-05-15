$(document).ready(function(){
	var mozL10n = document.mozL10n || document.webL10n;
    var nav_page = mozL10n.get('nav_page', null, 'Page');
    var find_msg = mozL10n.get('find_msg', null, 'Searching results…');
    var type_doc = mozL10n.get('type_doc', null, 'Memory');
    var result_cero = mozL10n.get('result_cero', null, 'No results were found...');
    
    var total_page = 1;
    var show_page = 1;
    //storage = navigator.getDeviceStorage("sdcard");
    
    $('.ui.icon.button.refresh').click(function(){
    	if ($('.ui.inbox.list.active').attr("data-tab") == "unread"){
    		show_page = 1;
	        total_page = 1;
            var files = document.getElementById("input").files;
	        load(files);
    	}    
    });
    $('.ui.pagination.sd .item.page_prev').click(function(){
        if(!$('.ui.pagination.sd .item.page_prev').hasClass('disabled')){
          if(show_page > 1){
            $('.ui.inbox.list a.item.page_'+show_page+'').hide();
            $('.ui.inbox.list a.item.page_'+(show_page-=1)+'').show();
            $('.ui.pagination.sd .item.page_next').removeClass("disabled");
            $('.page.pagination.sd').html(''+nav_page+' <b>'+show_page+'</b> / '+total_page+'')
            if (show_page == 1)
              $('.ui.pagination.sd .item.page_prev').addClass("disabled");
          }
        }    
      });
      $('.ui.pagination.sd .item.page_next').click(function(){
        if(!$('.ui.pagination.sd .item.page_next').hasClass('disabled')){
          if(show_page < total_page){
            $('.ui.inbox.list a.item.page_'+show_page+'').hide();
            $('.ui.inbox.list a.item.page_'+(show_page+=1)+'').show();
            $('.ui.pagination.sd .item.page_prev').removeClass("disabled");
            $('.page.pagination.sd').html(''+nav_page+' <b>'+show_page+'</b> / '+total_page+'')
            if (show_page == total_page)
              $('.ui.pagination.sd .item.page_next').addClass("disabled");
          }
        }
      });
   // load();
    function load(files){
      $('.ui.inbox.list.active').html('<a id="Message" class="active item">'+find_msg+'</a>');
      // $('.ui.segment.loader_pdf').show();
      var divided_pdf = 0;
      var style = "";
      
     // var all_files = storage.enumerate("");
     // all_files.onsuccess = function() {
        $('.ui.page.pdf').hide()
        var index = 0;
        while (files[index]) {
          var each_file = files[index]; //all_files.result;
          if (each_file.name.match(/.odt$/) || each_file.name.match(/.odp$/) || each_file.name.match(/.ods$/)) {
            //if (divided_pdf == 10){
            //  divided_pdf = 0;
            //  style="style='display:none;'";
            //  total_page++;
            // }
            divided_pdf++;
            ultimo = each_file.name.split("/").pop();
            pdf = ultimo.charAt(0).toUpperCase() + ultimo.slice(1);
            formato = ultimo.split(".")[1]
            if(formato == "odt"){
              $('.ui.inbox.list.active.unread').append(''+
                '<a '+style+' id="'+each_file.name+'" class="item ui pdf page_'+total_page+'">'+
                  '<div class="right floated date"> - Tipo: '+type_doc+' SD</div>'+
                  '<div class="left floated ui star rating"><img src="./images/'+formato+'.png" style=" width: 45px;"></i></div>'+
                  '<div class="description">' + pdf + '</div>'+
                '</a>'
              );
            }else if(formato == "odp"){
              $('.ui.inbox.list.saved').append(''+
                '<a '+style+' id="'+each_file.name+'" class="item ui pdf page_'+total_page+'">'+
                  '<div class="right floated date"> - Tipo: '+type_doc+' SD</div>'+
                  '<div class="left floated ui star rating"><img src="./images/'+formato+'.png" style=" width: 45px;"></i></div>'+
                  '<div class="description">' + pdf + '</div>'+
                '</a>'
              );
            }else if(formato == "ods"){
              $('.ui.inbox.list.all').append(''+
                '<a '+style+' id="'+each_file.name+'" class="item ui pdf page_'+total_page+'">'+
                  '<div class="right floated date"> - Tipo: '+type_doc+' SD</div>'+
                  '<div class="left floated ui star rating"><img src="./images/'+formato+'.png" style=" width: 45px;"></i></div>'+
                  '<div class="description">' + pdf + '</div>'+
                '</a>'
              );
            }
            
          }
          index++;
          //all_files.continue();
        }
        /*
        if (all_files.readyState != "pending"){
          $('#Message').remove();
          if ($('.ui.inbox.list.active a').size() == 0){
            $('.ui.inbox.list.active').html('<a id="Message" class="active item">'+result_cero+'</a>');
          }
          if ($('.ui.inbox.list.all a').size() == 0){
            $('.ui.inbox.list.all').html('<a id="Message" class="active item">'+result_cero+'</a>');
          }
          if ($('.ui.inbox.list.saved a').size() == 0){
            $('.ui.inbox.list.saved').html('<a id="Message" class="active item">'+result_cero+'</a>');
          }
          $('.ui.page.pdf').show()
          $('.ui.segment.loader_pdf').hide();   
        }
        */

       /* if (total_page > 1){
          $('.page.pagination.sd').html(''+nav_page+' <b>'+show_page+'</b> / '+total_page+'')
          $('.ui.pagination.sd .item.page_next').removeClass("disabled");
        }*/

        $('.ui.inbox.list a').click(function(){
          if ($(this).attr("id") != "Message"){
            var fileName = $(this).attr("id");
            $("#title_pdf").html(''+$(this).children('p').html()+'');
            var iframe = '<IFRAME id="iframe" SRC="./viewer/index.html#'+fileName+'" WIDTH=99.9% HEIGHT=100% FRAMEBORDER=1 scrolling="no"></IFRAME>';
            $(".menu_principal").hide();
            $(".ui.celled.grid.content").hide();
            $(".ui.celled.grid.viewer").show();
            $(".ui.celled.grid.viewer").html(iframe);
            $(".ui.menu.fixed_buttom").show();
            formato = fileName.split(".")[1]
            if (formato == "odp"){
              $(".ui.celled.grid.viewer iframe").load(function(){
                $(this).contents().find(".ui.dimmer.active").hide();
              });
            }
          }
        });
        $(".reply.mail.big.icon").click(function(){
            $(".menu_principal").show();
            $(".ui.celled.grid.content.principal").show();
            $(".ui.celled.grid.viewer").hide();
            $(".ui.celled.grid.viewer iframe").remove()
            $(".ui.menu.fixed_buttom").hide();
            $('.menu_top.sidebar')
              .sidebar('hide')
            ;
        });
      //};

      /*
      all_files.onerror = function(){
          console.log("error al leer archivos");
      }
      */
    }
});
