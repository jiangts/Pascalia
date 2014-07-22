
/*
Adapted from http://fabricjs.com/stickman/
 */

(function() {
  var canvas, paintCell, paintCircle;

  canvas = new fabric.Canvas('c', {
    selection: false
  });

  fabric.Object.prototype.originX = fabric.Object.prototype.originY = 'center';

  paintCell = function(left, top) {
    var c;
    c = new fabric.Text('hello world', {
      left: left,
      top: top,
      fontSize: 18,
      lockMovementX: true,
      lockMovementY: true
    });
    c.hasControls = c.hasBorders = false;
    return c;
  };

  paintCircle = function(left, top) {
    var c;
    c = new fabric.Circle({
      left: left,
      top: top,
      radius: '20',
      lockMovementX: true,
      lockMovementY: true
    });
    c.hasControls = c.hasBorders = false;
    return c;
  };

  canvas.add(paintCell(500, 500), paintCell(102, 30), paintCell(24, 24), paintCell(325, 73));

}).call(this);
