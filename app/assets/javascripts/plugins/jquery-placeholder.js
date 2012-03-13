/*
	jQuery Placeholder Plugin
	Author: Eymen Gunay
	Web: http://www.egunay.com/
*/
(function( $ ){
	$.fn.placeHolder = function(options) {
		var NATIVE_SUPPORT = !!("placeholder" in document.createElement( "input" ));
		var settings = {
			'text'		  : 'Placeholder',
			'placeholder' : '#999',
			'active' 	  : '#000'
		};
		return NATIVE_SUPPORT ? this : this.each(function() {        
			if ( options ) { 
				$.extend( settings, options );
			}
			// Set placeholder text			
			$(this).val(settings.text);
			// Set placeholder text color
			$(this).css("color", settings.placeholder);
			// Autofocus
			settings.autofocus == true || $(this).attr("autofocus") == "autofocus" ? $(this).focus() : '';
			// On keydown (autofocus fix)
			$(this).keydown(function(e) {
                if (settings.autofocus == true || $(this).attr("autofocus") == "autofocus") {
					$(this).val("");
					$(this).css("color", settings.active);
					settings.autofocus = false;
					settings.autofocus = $(this).removeAttr("autofocus");
				}
            });
			// On focus
			$(this).focus(function(e) {
				if($(this).val() == settings.text && !settings.autofocus && $(this).attr("autofocus") != "autofocus") {
					$(this).css("color", settings.active);
					$(this).val("");	
				}
			});
			// On focusout
			$(this).focusout(function() {
				if($(this).val() == "" || $(this).val() == settings.text) {
					$(this).val(settings.text);
					$(this).css("color", settings.placeholder);
					settings.autofocus || $(this).attr("autofocus") == "autofocus" ? settings.autofocus = false : '';
				}
			});
		});				
	};
})( jQuery );