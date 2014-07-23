
/*
Adapted from http://stackoverflow.com/questions/4288253/html5-canvas-100-width-height-of-viewport
 */

(function() {
  var canvas, context, resizeCanvas;

  canvas = $('#c')[0];

  context = canvas.getContext('2d');

  resizeCanvas = function() {
    canvas.width = window.innerWidth;
    return canvas.height = window.innerHeight;

    /*
     Your drawings need to be inside this function otherwise they will be reset when 
     you resize the browser window and the canvas goes will be cleared.
     */
  };

  resizeCanvas();

}).call(this);
