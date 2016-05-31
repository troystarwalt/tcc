$(document).ready(function(){

	var hideCarouselForm = $('#hideCarousel');
	var hideCarouselInput = $('#hideCarousel > input');
	var status = hideCarouselInput.attr('value');
	//status is the input attribute 'value' upon page load

	console.log('load status: ' + status)
	hideCarouselForm.submit(function() {
	  //posts the contents of the form to /action using ajax
	  if (status === 'false') { 
	  //We want to show the carousel. it should currently be hidden.
  		hideCarouselInput.attr('value', 'true');
  		status = hideCarouselInput.attr('value');
	  	$.post("hideShowCarousel", hideCarouselForm.serialize(), function(data){
	  	});
	  	$('.hideShowButton').text('Hide Carousel');
	  }
	  else {
	  	//We want to hide the carousel it should currently be shown.
	  	hideCarouselInput.attr('value', 'false');
  		status = hideCarouselInput.attr('value');
	  	$.post("hideShowCarousel", hideCarouselForm.serialize(), function(data){
	  		//shown
	  	});
	  	$('.hideShowButton').text('Show Carousel');
	  }
	  return false; // prevents the form from submitting normally
	});
});