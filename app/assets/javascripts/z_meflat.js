ready = function() {
	/*============================================
	Footer pop Weixin
	==============================================*/
	$('#icon-weixin2').popover({
      html: true,
      placement: 'top',
      title: '扫描二维码加微信',
      content: function(){
        return $('#weixin-qrcode2').html();
      }
  });
	/*============================================
	Navigation Functions
	==============================================*/
	if ($(window).scrollTop()===0){
		$('#main-nav').removeClass('scrolled');
	}
	else{
		$('#main-nav').addClass('scrolled');    
	}

	$(window).scroll(function(){
		if ($(window).scrollTop()===0){
			$('#main-nav').removeClass('scrolled');
		}
		else{
			$('#main-nav').addClass('scrolled');    
		}
	});
	
	/*============================================
	Header Functions
	==============================================*/
	$('.imac-screen').flexslider({
		prevText: '<i class="fa fa-angle-left"></i>',
		nextText: '<i class="fa fa-angle-right"></i>',
		animation: 'slide',
		slideshowSpeed: 3000,
		useCSS: true,
		controlNav: false,
		directionNav: false,
		pauseOnAction: false, 
		pauseOnHover: false,
		smoothHeight: false
	});
	
	$("#home .text-col h1").fitText(0.9, { minFontSize: '32px', maxFontSize: '62px' });
	$("#home .text-col p").fitText(1.2, { minFontSize: '12px', maxFontSize: '32px' });
	
	$('.imac-screen img').load(function(){
		$('#home .text-col h1, #home .text-col p, #home .imac-frame').addClass('in');
	});
	
	/*============================================
	Skills Functions
	==============================================*/

	
	/*============================================
	Project thumbs - Masonry
	==============================================*/
	$(window).load(function(){

		$('#projects-container').css({visibility:'visible'});

		$('#projects-container').masonry({
			itemSelector: '.project-item:not(.filtered)',
			columnWidth:320,
			isFitWidth: true,
			isResizable: true,
			isAnimated: !Modernizr.csstransitions,
			gutterWidth: 25
		});

		scrollSpyRefresh();
		waypointsRefresh();
	});

	/*============================================
	Filter Projects
	==============================================*/
	$('#filter-works a').click(function(e){
		e.preventDefault();

		$('#filter-works li').removeClass('active');
		$(this).parent('li').addClass('active');

		var category = $(this).attr('data-filter');

		$('.project-item').each(function(){
			if($(this).is(category)){
				$(this).removeClass('filtered');
			}
			else{
				$(this).addClass('filtered');
			}

			$('#projects-container').masonry('reload');
		});

		scrollSpyRefresh();
		waypointsRefresh();
	});

	/*============================================
	Template show slider
	==============================================*/
	setTimeout(function(){
		$('.screen.flexslider').flexslider({
			prevText: '<i class="fa fa-angle-left"></i>',
			nextText: '<i class="fa fa-angle-right"></i>',
			slideshowSpeed: 3000,
			animation: 'slide',
			controlNav: false,
			pauseOnAction: false, 
			pauseOnHover: true,
			start: function(){
				$('#project-modal .screen')
				.addClass('done')
				.prev('.loader').fadeOut();
			}
		});
	},1000);
	/*============================================
	Project Preview --xj removed
	==============================================*/
	
	
	/*============================================
	ScrollTo Links
	==============================================*/
	$('a.scrollto').click(function(e){
		$('html,body').scrollTo(this.hash, this.hash, {gap:{y:-50},animation:  {easing: 'easeInOutCubic', duration: 1600}});
		e.preventDefault();

		if ($('.navbar-collapse').hasClass('in')){
			$('.navbar-collapse').removeClass('in').addClass('collapse');
		}
	});

	/*============================================
	Contact Form
	==============================================*/
	
	$(".label_better").label_better({
	  easing: "bounce",
	  offset:5
	});

	/*============================================
	Tooltips
	==============================================*/
	$("[data-toggle='tooltip']").tooltip();
	
	/*============================================
	Placeholder Detection
	==============================================*/
	if (!Modernizr.input.placeholder) {
		$('#contact-form').addClass('no-placeholder');
	}

	/*============================================
	Scrolling Animations
	==============================================*/
	$('.scrollimation').waypoint(function(){
		$(this).addClass('in');
	},{offset:function(){
			var h = $(window).height();
			var elemh = $(this).outerHeight();
			if ( elemh > h*0.3){
				return h*0.7;
			}else{
				return h - elemh;
			}
		}
	});

	/*============================================
	Resize Functions
	==============================================*/
	$(window).resize(function(){
		scrollSpyRefresh();
		waypointsRefresh();
	});

};	

/*======================================下面是burbolinks改造后的调用方法===============================================*/
//#turbolinks style
$(document).ready(ready);
$(document).on('page:load', ready);

/*======================================引入turbolinks后，上面的masonry调用失效，故新添加次方法============================
====参考： http://stackoverflow.com/questions/14259898/masonry-images-overlapping-issue-with-rails-3-turbolinks-mozilla*/
$(document).on('page:load', function(){

	$('#projects-container').css({visibility:'visible'});
	$('#projects-container').waitForImages({
	    finished: function() {
	      var $container;
	      $container = $("#projects-container");
	      $container.imagesLoaded(function() {
	      	return $container.masonry({
					itemSelector: '.project-item:not(.filtered)',
					columnWidth:320,
					isFitWidth: true,
					isResizable: true,
					isAnimated: !Modernizr.csstransitions,
					gutterWidth: 25
	      	});
	      });
	    },
	    each: function() {
	      
	    },
	    waitForAll: true
	});
	scrollSpyRefresh();
	waypointsRefresh();
});


/*======================================下面是公共方法====================================================================*/
/*============================================
Refresh scrollSpy function
==============================================*/
function scrollSpyRefresh(){
	setTimeout(function(){
		$('body').scrollspy('refresh');
	},1000);
}

/*============================================
Refresh waypoints function
==============================================*/
function waypointsRefresh(){
	setTimeout(function(){
		$.waypoints('refresh');
	},1000);
}

/*======================================下面是公共方法====================================================================*/
