/* This css is for /price 
 * Source from: http://wbpreview.com/previews/WB07C692G/;
 */
ready = function() {
  $('.pricing-table .plan').mouseover(function() {
    var plan = $(this);
    plan.addClass('plan-mouseover');
  }).mouseout(function() {
    var plan = $(this);
    plan.removeClass('plan-mouseover');
  });
};


/*======================================下面是burbolinks改造后的调用方法===============================================*/
//#turbolinks style
$(document).ready(ready);
$(document).on('page:load', ready);

