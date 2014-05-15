$(document).ready(function() {
	var mozL10n = document.mozL10n || document.webL10n;
	$('.ui.submit.button.email').click(function(){
	    var data = {
	        'email': $('#email').val()
	    };
	    $('.ui.segment.loader_pdf').show();
		if(data.email.indexOf('@', 0) == -1 || data.email.indexOf('.', 0) == -1) {
			var email_incorrect = mozL10n.get('email_incorrect', null, 'The email you have entered is incorrect.');
            alert(email_incorrect);
            $('.ui.segment.loader_pdf').hide();
        }else{
		    if (navigator.onLine === false) {
		    	  var connect_msg = mozL10n.get('connect_msg', null, 'Network connection unavailable.');
		          alert(connect_msg);
		    } else {
		        $.getJSON(
		          "http://pdfviewer2.appspot.com/buscador/save_correos/",
		          data,
		          	function (data) {
		              	if (data != undefined && data.success == true) {
		              		var send_email = mozL10n.get('send_email', null, 'Your Email has been sent.');
		                  	alert(send_email)
		                  	$('.ui.segment.loader_pdf').hide(); 
		              	}
		    		}  
		    	)
		        .error(function () {
		        	 var send_email_error = mozL10n.get('send_email_error', null, 'There was an error sending email try again.');
		             alert(send_email_error);
		             $('.ui.segment.loader_pdf').hide(); 
		        })
		    }
	    }
	});
	$('.ui.button.contact_form').click(function(){
	    var data = {
	        'name': $('#name').val(),
	        'message': $('#message').val(),
	        'email_contact': $('#email_contact').val()
	    };
	   	$('.ui.segment.loader_pdf').show();
	    if(data.email_contact.indexOf('@', 0) == -1 || data.email_contact.indexOf('.', 0) == -1) {
			var email_incorrect = mozL10n.get('email_incorrect', null, 'The email you have entered is incorrect.');
            alert(email_incorrect);
            $('.ui.segment.loader_pdf').hide();
        }else{
		    if (navigator.onLine === false) {
		    		var connect_msg = mozL10n.get('connect_msg', null, 'Network connection unavailable.');
		          alert(connect_msg);
		    } else {
		        $.getJSON(
		          "http://pdfviewer2.appspot.com/buscador/form_contact/",
		          data,
		          	function (data) {
		              	if (data != undefined && data.success == true) {
		              		var send_msg = mozL10n.get('send_msg', null, 'Your Message has been sent.');
		                  	alert(send_msg);
		                  	$('.ui.segment.loader_pdf').hide(); 
		              	}
		    		}  
		    	)
		        .error(function () {
		        	var send_msg_error = mozL10n.get('send_msg_error', null, 'There was an error sending message try again.');
		          	alert(send_msg_error);
		            $('.ui.segment.loader_pdf').hide(); 
		        })
		    }
		}
	});
});