$(document).ready(function(){
  
	$('#toggle-switcher').click(function(){
		if($(this).hasClass('opened')){
			$(this).removeClass('opened');
			$('#style-switcher').animate({'right':'-222px'});
		}else{
			$(this).addClass('opened');
			$('#style-switcher').animate({'right':'-10px'});
		}
	});
	
	$('#style-switcher li').click(function(e){
		e.preventDefault();
		
		$elem = $(this);
		
		$('link#theme').attr('href', 'style/thume-'+$elem.attr('id')+'.css');
		
		var color = $(this).css('backgroundColor');

		$('.row.skills .col-sm-6').remove();
		$('.row.skills').append('\
		<div class="col-sm-6 col-md-3 text-center">\
			<span class="chart" data-percent="80"><span class="percent">80</span></span>\
			<h2 class="text-center">Web Design</h2>\
		</div>\
		<div class="col-sm-6 col-md-3 text-center">\
			<span class="chart" data-percent="70"><span class="percent">70</span></span>\
			<h2 class="text-center">HTML / CSS</h2>\
		</div>\
		<div class="col-sm-6 col-md-3 text-center">\
			<span class="chart" data-percent="60"><span class="percent">60</span></span>\
			<h2 class="text-center">Graphic Design</h2>\
		</div>\
		<div class="col-sm-6 col-md-3 text-center">\
			<span class="chart" data-percent="90"><span class="percent">90</span></span>\
			<h2 class="text-center">UI / UX</h2>\
		</div>');

		$('.chart').each(function(){
		$(this).easyPieChart({
				size:140,
				animate: 2000,
				lineCap:'butt',
				scaleColor: false,
				barColor: color,
				trackColor: 'transparent',
				lineWidth: 10
			});
		});
		
		$('link#theme').load(function(){
			$('link#main').attr('href', 'style/thume-'+$elem.attr('id')+'.css');
		});
	});
});