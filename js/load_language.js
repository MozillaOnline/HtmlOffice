$(document).ready(function(){
    var mozL10n = document.mozL10n || document.webL10n;    
    var locale = navigator.language;
    $('.item.lang.'+locale+'').css({"background-color": "rgba(0,0,0,.03)", "-webkit-box-shadow": "none", "box-shadow": "none", "border-color": "#D95C5C", "color": "#D95C5C"});
    mozL10n.setLanguage(locale);
    function ocult_mas(){
        $('.item.bot.ocult_mas').hide();
        $('.item.bot.ver_mas').show();
        $('.item.lang.pl').hide();
        $('.item.lang.ar').hide();
        $('.item.lang.fr').hide();
    }
    $('.item.bot.ver_mas').click(function(){
        $('.item.bot.ver_mas').hide();
        $('.item.bot.ocult_mas').show();
        $('.item.lang.pl').show();
        $('.item.lang.ar').show();
        $('.item.lang.fr').show();
    });
    $('.item.bot.ocult_mas').click(function(){
        ocult_mas();
    });
    function change_lang(lang){
        $('.item.lang').removeAttr('style');
        $('.item.lang').removeClass('active');
                $('.item.lang.'+lang+'').addClass('active');
        $('.ui.menu_left.sidebar.menu').removeClass('active');
        mozL10n.setLanguage(''+lang+'');
        ocult_mas();

    }
    $('.item.lang.en-US').click(function(){
        change_lang("en-US");
        $('#email').attr('placeholder',"E-mail");
        $('#search').attr('placeholder',"Enter a keyword");
    });
    $('.item.lang.es').click(function(){
        change_lang("es");
        $('#email').attr('placeholder',"Correo electrónico");
        $('#search').attr('placeholder',"Intro, Palabra clave:");
    });
    $('.item.lang.pl').click(function(){
        change_lang("pl");
        $('#email').attr('placeholder',"E-mail");
        $('#search').attr('placeholder',"Enter a keyword.");
    });
    $('.item.lang.ar').click(function(){
        change_lang("ar");
        $('#email').attr('placeholder',"البريد الإلكتروني");
        $('#search').attr('placeholder',"أدخل كلمة أساسية.");
    });
    $('.item.lang.fr').click(function(){
        change_lang("fr");
        $('#email').attr('placeholder',"E-mail");
        $('#search').attr('placeholder',"Entrez un mot-clé.");
    });
});
