
/*
Adapted from http://stackoverflow.com/questions/4288253/html5-canvas-100-width-height-of-viewport
 */

(function() {
  var Cell, Painter, Parent, Pascal, canvas, context, p1, p2, p3, painter, resizeCanvas,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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

  Cell = (function() {
    function Cell(options) {
      if (options.value == null) {
        options.value = 0;
      }
      this.level = options.level, this.index = options.index, this.value = options.value;
    }

    Cell.prototype.choose = function(a, b) {
      var denom, num, _i, _j, _ref, _results, _results1;
      if (b > a || a < 0 || b < 0) {
        console.log("input error: a = " + a + ", b = " + b);
        return false;
      }
      if (b > a - b) {
        b = a - b;
      }
      if (b === 0) {
        return 1;
      }
      num = (function() {
        _results = [];
        for (var _i = _ref = a - b + 1; _ref <= a ? _i <= a : _i >= a; _ref <= a ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this).reduce(function(prevVal, currVal) {
        return prevVal * currVal;
      });
      denom = (function() {
        _results1 = [];
        for (var _j = 1; 1 <= b ? _j <= b : _j >= b; 1 <= b ? _j++ : _j--){ _results1.push(_j); }
        return _results1;
      }).apply(this).reduce(function(prevVal, currVal) {
        return prevVal * currVal;
      });
      return num / denom;
    };

    return Cell;

  })();

  Parent = (function(_super) {
    __extends(Parent, _super);

    function Parent(options) {
      if (options.level == null) {
        options.level = 0;
      }
      if (!options.value) {
        console.log("parent must have initial value!");
        return false;
      }
      Parent.__super__.constructor.call(this, options);
    }

    Parent.prototype.getChildren = function(level) {
      var abslev, idx, lev, out, _i, _j, _ref, _ref1;
      out = [];
      for (lev = _i = _ref = this.level + 1, _ref1 = this.level + level; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; lev = _ref <= _ref1 ? ++_i : --_i) {
        abslev = Math.abs(this.level - lev);
        for (idx = _j = 0; 0 <= abslev ? _j <= abslev : _j >= abslev; idx = 0 <= abslev ? ++_j : --_j) {
          out.push(new Cell({
            level: lev,
            index: this.index + idx
          }));
        }
      }
      return out;
    };

    Parent.prototype.hasChild = function(cell) {
      var _ref;
      return (this.index <= (_ref = cell.index) && _ref <= (this.index + cell.level));
    };

    return Parent;

  })(Cell);

  Pascal = (function() {
    function Pascal() {
      this.cells = [];
      this.parents = [];
    }

    Pascal.prototype.addCell = function(cell) {
      var c;
      c = this.hasCell(cell);
      if (!c) {
        this.cells.push(cell);
        if (cell instanceof Parent) {
          this.parents.push(cell);
        }
        return cell;
      }
    };

    Pascal.prototype.addCells = function(cells) {
      var cell, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = cells.length; _i < _len; _i++) {
        cell = cells[_i];
        _results.push(this.addCell(cell));
      }
      return _results;
    };

    Pascal.prototype.hasCell = function(cell) {
      if (this.locate(cell.level, cell.index)) {
        return cell;
      } else {
        return false;
      }
    };

    Pascal.prototype.locate = function(_level, _index) {
      var c, cell, _i, _len, _ref;
      _ref = this.cells;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        if (cell.level === _level && cell.index === _index) {
          c = cell;
        }
      }
      return c != null ? c : null;
    };

    Pascal.prototype.populate = function(level) {
      var parent, _i, _len, _ref, _results;
      _ref = this.parents;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parent = _ref[_i];
        _results.push(this.addCells(parent.getChildren(level)));
      }
      return _results;
    };

    Pascal.prototype.calculateCell = function(cell) {
      var p, _i, _len, _ref;
      _ref = this.parents;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        if (p.hasChild(cell)) {
          cell.value += (cell.choose(Math.abs(cell.level - p.level), Math.abs(cell.index - p.index))) * p.value;
        }
      }
      return cell.value;
    };

    Pascal.prototype.calculate = function() {
      var cell, i, _i, _len, _ref, _results;
      _ref = this.cells;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        cell = _ref[i];
        if (cell instanceof Parent === false) {
          cell.value = this.calculateCell(cell);
          _results.push(this.cells[i] = cell);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return Pascal;

  })();


  /*
  Catalan Example
  for i in [1..10]
    console.log pascal.calculateCell new Cell level:(2*i), index:i
   */


  /*
  Adapted from http://fabricjs.com/stickman/
   */

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
    index: 0,
    value: 1
  });

  p2 = new Parent({
    index: -1,
    value: -1
  });

  p3 = new Parent({
    index: -1,
    value: 2
  });

  painter = new Painter([p1, p2], 20);

  painter.paint();

}).call(this);
