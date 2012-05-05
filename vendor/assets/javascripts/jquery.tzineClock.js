/*!
 * jquery.tzineClock.js - Tutorialzine Colorful Clock Plugin
 *
 * Copyright (c) 2009 Martin Angelov
 * http://tutorialzine.com/
 *
 * Licensed under MIT
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Launch  : December 2009
 * Version : 1.0
 * Released: Monday 28th December, 2009 - 00:00
 */

(function($){
	
	// A global array used by the functions of the plug-in:
	var gVars = {};

	// Extending the jQuery core:
	$.fn.tzineClock = function(opts){
	
		// "this" contains the elements that were selected when calling the plugin: $('elements').tzineClock();
		// If the selector returned more than one element, use the first one:
		
		var container = this.eq(0);
	
		if(!container)
		{
			try{
				console.log("Invalid selector!");
			} catch(e){}
			
			return false;
		}
		
		if(!opts) opts = {}; 
		
		var defaults = {
			/* Additional options will be added in future versions of the plugin. */
		};
		
		/* Merging the provided options with the default ones (will be used in future versions of the plugin): */
		$.each(defaults,function(k,v){
			opts[k] = opts[k] || defaults[k];
		})

		// Calling the setUp function and passing the container,
		// will be available to the setUp function as "this":
		setUp.call(container);
		
		return this;
	}
	
	function setUp()
	{
		// The colors of the dials:
		var colors = ['red', 'brown','grey','white'];
		
		var tmp;
		
		for(var i=0;i<4;i++)
		{
			// Creating a new element and setting the color as a class name:
			var text;
			switch(i){
				case 0: text = "Days"; break;
				case 1: text = "Hours"; break;
				case 2: text = "Minutes"; break;
				case 3: text = "Seconds"; break;
			}
			var text 

			tmp = $('<div>').attr('class',colors[i]+' clock').html(
				'<div class="text">'+text+'</div>' +
				'<div class="display"></div>'+
				
				'<div class="front left"></div>'+
				
				'<div class="rotate left">'+
					'<div class="bg left"></div>'+
				'</div>'+
				
				'<div class="rotate right">'+
					'<div class="bg right"></div>'+
				'</div>'
			);
			
			// Appending to the container:
			$(this).append(tmp);
			
			// Assigning some of the elements as variables for speed:
			tmp.rotateLeft = tmp.find('.rotate.left');
			tmp.rotateRight = tmp.find('.rotate.right');
			tmp.display = tmp.find('.display');
			
			// Adding the dial as a global variable. Will be available as gVars.colorName
			gVars[colors[i]] = tmp;
		}
		
		// Setting up a interval, executed every 1000 milliseconds:
		setInterval(function(){
		 	var days, hours, minutes, seconds;

		  var now = new Date();
		  now.getTime();
		  var time = Date.parse(now);
		  
		  var release = Date.parse("Su, 03 Jun 2012 00:00:00 GMT+1");
		  
		  var diff = release - time;
		  
		  if (diff < 0){
		    days = hours = minutes = seconds = "00";
		  }
		  else {
		    var diff = diff /1000;
		    
		    days = Math.floor( diff/(60*60*24) );
		    //if(days < 10) days = "0"+days;
		    
		    hours = Math.floor( (diff - days*24*60*60)/(60*60) );
		    //if(hours < 10) hours = "0"+hours;
		    
		    minutes = Math.floor( (diff - days*24*60*60 - hours*60*60)/60);
		    //if(minutes < 10) minutes = "0"+minutes;
		    
		    seconds = Math.floor( diff - days*24*60*60 - hours*60*60 - minutes*60);
		    //if(seconds < 10) seconds = "0"+seconds;
		  }

			animation(gVars.red, days, 100);	
			animation(gVars.brown, hours, 24);
			animation(gVars.grey, minutes, 60);
			animation(gVars.white, seconds, 60);

			if(days < 10) days = "0"+days;
			if(hours < 10) hours = "0"+hours;
			if(minutes < 10) minutes = "0"+minutes;
			if(seconds < 10) seconds = "0"+seconds;

			$('#days').html(days+" d :");
			$('#hours').html(hours+" h :");
			$('#minutes').html(minutes+" m :");
			$('#seconds').html(seconds+" s");
				
		},1000);
	}
	
	function animation(clock, current, total)
	{
		// Calculating the current angle:
		var angle = (360/total)*(current+1);
	
		var element;

		if(current==0)
		{
			// Hiding the right half of the background:
			clock.rotateRight.hide();
			
			// Resetting the rotation of the left part:
			rotateElement(clock.rotateLeft,0);
		}
		
		if(angle<=180)
		{
			clock.rotateRight.hide();
			// The left part is rotated, and the right is currently hidden:
			element = clock.rotateLeft;
		}
		else
		{
			// The first part of the rotation has completed, so we start rotating the right part:
			clock.rotateRight.show();
			clock.rotateLeft.show();
			
			rotateElement(clock.rotateLeft,180);
			
			element = clock.rotateRight;
			angle = angle-180;
		}

		rotateElement(element,angle);
		
		// Setting the text inside of the display element, inserting a leading zero if needed:
		clock.display.html(current<10?'0'+current:current);
	}
	
	function rotateElement(element,angle)
	{
		// Rotating the element, depending on the browser:
		var rotate = 'rotate('+angle+'deg)';

		if(element.css('msTransform')!=undefined)
			element.css({msTransform: rotate});

		if(element.css('MozTransform')!=undefined)
			element.css('MozTransform',rotate);
			
		if(element.css('WebkitTransform')!=undefined)
			element.css('WebkitTransform',rotate);
	
		// A version for internet explorer using filters, works but is a bit buggy (no surprise here):
		if(element.css("filter")!=undefined)
		{
			var cos = Math.cos(Math.PI * 2 / 360 * angle);
			var sin = Math.sin(Math.PI * 2 / 360 * angle);
			
			element.css("filter","progid:DXImageTransform.Microsoft.Matrix(M11="+cos+",M12=-"+sin+",M21="+sin+",M22="+cos+",SizingMethod='auto expand',FilterType='nearest neighbor')");
	
			element.css("left",(-Math.floor((element.width()-70)/2))+"px");
			element.css("top",(-Math.floor((element.height()-70)/2))+"px");
		}
	
	}
	
})(jQuery)