$(document)
  .ready(function() {
    var mozL10n = document.mozL10n || document.webL10n;
     
    $('.filter.menu .item')
      .tab()
    ;

    $('.ui.menu .item')
      .tab()
    ;

    $('#unread').click(function(){
      $('.page_sd').hide();
      $('.page_sd.odt').show();
    });
    $('#saved, .ui.icon.button.buscar_open').click(function(){
      $('.page_sd').hide();
      $('.page_sd.odp').show();
    });

    $('#all').click(function(){
      $('.page_sd').hide();
      $('.page_sd.ods').show();
    });

    $('.ui.rating')
      .rating({
        clearable: true
      })
    ;

    $('.menu_left.sidebar')
      .sidebar({
        overlay: true
      })
      .sidebar('attach events', '.click_menu')
    ;

    $('.menu_top.sidebar')
      .sidebar({
        overlay: true
      })
      .sidebar('attach events', '.m_top')
    ;

    $('.contacts.sidebar')
      .sidebar({
        overlay: true
      })
      .sidebar('attach events', '.contact')
    ;
    
    $('.ui.dropdown')
      .dropdown()
    ;

    $('.ui.accordion')
      .accordion()
    ;

    $('.help.icon').parent().click(function(){
        $('.ui.celled.grid.content.principal').hide();
        $('.ui.celled.grid.content.advertising').hide();
        $('.ui.icon.button.buscar_open').parent().hide();
        $('.ui.message.help').show();

        $(".menu_principal").show();
            /*$(".ui.celled.grid.content").show();*/
            $(".ui.celled.grid.viewer").hide();
            $(".ui.celled.grid.viewer iframe").remove()
            $(".ui.menu.fixed_buttom").hide();
            $('.menu_top.sidebar')
              .sidebar('hide')
            ;
            $('.ui.menu_left.sidebar.menu').removeClass('active');
    });
    $('.advertising.icon').parent().click(function(){
        $('.ui.celled.grid.content.principal').hide();
        $('.ui.icon.button.buscar_open').parent().hide();
        $('.ui.celled.grid.content.advertising').show();
        $('#iframe_ads').attr("src","http://pdfviewer2.appspot.com/");
        $(".menu_principal").show();
            /*$(".ui.celled.grid.content").show();*/
        $(".ui.celled.grid.viewer").hide();
        $(".ui.celled.grid.viewer iframe").remove()
        $(".ui.menu.fixed_buttom").hide();
        $('.menu_top.sidebar')
          .sidebar('hide')
        ;
        $('.ui.menu_left.sidebar.menu').removeClass('active');
    });
    $('.contact').click(function(){
        $('.ui.menu_left.sidebar.menu').removeClass('active');
    });
    $('.reply.mail.help, .active.home.icon').parent().click(function(){
        $('.ui.celled.grid.content.principal').show();
        $('.ui.icon.button.buscar_open').parent().show();
        $('.ui.message.help').hide();
        $('.ui.celled.grid.content.advertising').hide();
        $(".ui.menu.fixed_buttom").hide();
        
        $(".menu_principal").show();
            $(".ui.celled.grid.content.principal").show();
            $(".ui.celled.grid.viewer").hide();
            $(".ui.celled.grid.viewer iframe").remove()
            $(".ui.menu.fixed_buttom").hide();
            $('.menu_top.sidebar')
              .sidebar('hide')
            ;
            $('.ui.menu_left.sidebar.menu').removeClass('active');
    });
    $('.ui.modal.email.foxxapp')
      .modal('setting', {
        onShow    : function(){
          var web_construction = mozL10n.get('web_construction', null, 'Sorry, our web page is actually in construction. If you like it, you can register your e-mail to stay pending of our latest news.');
          window.alert(web_construction);
        }
      })
      .modal('attach events', '.ui.image.foxxapp, .ui.button.signup', 'show')
    ;
    $('.ui.modal.email.foxxapp')
      .parent().css({"margin":"0"})
    ;
    if (navigator.onLine === false) {
        $('.ui.grid.advertising.offine').parent().show();
        $('.ui.grid.advertising.online').parent().hide();
    }else{
        $('.ui.grid.advertising.offine').parent().hide();
        $('.ui.grid.advertising.online').parent().show();
        $('.ui.grid.advertising.loading').parent().hide();
    }
    $(".link_microsoft").click(function(){
      var url = $(this).attr("url");
      new MozActivity({
        name: "ads",
          data: {
              type: "url", // Possibly text/html in future versions
              url: url
          },
      });
    });
  })
;