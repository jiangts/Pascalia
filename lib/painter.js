
/*
Adapted from http://fabricjs.com/stickman/
 */

(function() {
  var Painter, canvas, p1, p2, p3, painter,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Painter = (function(_super) {
    __extends(Painter, _super);

    function Painter(parents, depth, sep) {
      this.sep = sep != null ? sep : 40;
      Painter.__super__.constructor.call(this);
      this.addCells(parents);
      this.populate(depth);
      this.calculate();
    }

    Painter.prototype.paint = function() {
      var cell, _i, _len, _ref;
      _ref = this.cells;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        canvas.add(this.createCell(cell));
      }
      return canvas.renderAll();
    };

    Painter.prototype.createCell = function(cell) {
      var left, top, value;
      value = cell.value.toString();
      left = canvas.width / 2 - ((cell.level - 2 * cell.index) * this.sep / Math.sqrt(3));
      top = (cell.level + 1) * this.sep;
      return this.paintCell(value, left, top);
    };

    Painter.prototype.paintCell = function(value, left, top) {
      var c, color;
      switch (false) {
        case !(value < 0):
          color = 'red';
          break;
        case !(value > 0):
          color = 'green';
          break;
        default:
          color = 'blue';
      }
      c = new fabric.Text(value, {
        left: left,
        top: top,
        fill: color,
        fontSize: 20,
        lockMovementX: true,
        lockMovementY: true
      });
      c.hasControls = c.hasBorders = false;
      return c;
    };

    Painter.prototype.resizeCells = function() {
      var cell, _i, _len, _ref, _results;
      _ref = canvas.getObjects();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        _results.push(cell.scaleToWidth(this.sep));
      }
      return _results;
    };

    return Painter;

  })(Pascal);

  canvas = new fabric.Canvas('c', {
    selection: false
  });

  fabric.Object.prototype.originX = fabric.Object.prototype.originY = 'center';

  p1 = new Parent({
    index: 1,
    value: 1
  });

  p2 = new Parent({
    index: 0,
    value: -3
  });

  p3 = new Parent({
    index: -1,
    value: 2
  });

  painter = new Painter([p1, p2, p3], 20);

  painter.paint();

}).call(this);
