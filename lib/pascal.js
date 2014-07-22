(function() {
  var Cell, Parent, Pascal, parent, pascal,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Cell = (function() {
    function Cell(options) {
      this.level = options.level, this.index = options.index, this.value = options.value;
    }

    return Cell;

  })();

  Parent = (function(_super) {
    __extends(Parent, _super);

    function Parent() {
      return Parent.__super__.constructor.apply(this, arguments);
    }

    Parent.prototype.getChildren = function(level) {};

    Parent.prototype.testChild = function(position) {
      var _ref;
      if ((this.index <= (_ref = position.index) && _ref <= (this.index + position.level))) {
        return true;
      } else {
        return false;
      }
    };

    return Parent;

  })(Cell);

  Pascal = (function() {
    function Pascal() {
      this.cells = [];
    }

    Pascal.prototype.addCell = function(cell) {
      return this.cells.push(cell);
    };

    Pascal.prototype.addCells = function(cells) {
      return this.cells.concat(cells);
    };

    Pascal.prototype.locate = function(_level, _index) {
      var cell, out, _i, _len, _ref;
      _ref = this.cells;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        if (cell.level === _level && cell.index === _index) {
          out = cell;
        }
      }
      return out != null ? out : "does not exist";
    };

    return Pascal;

  })();

  parent = new Parent({
    level: 0,
    index: 1,
    value: 1
  });

  pascal = new Pascal;

  pascal.addCell(parent);

  console.log(pascal.locate(0, 1));

  console.log(pascal.locate(1, 1));

  console.log(pascal.cells);

}).call(this);
