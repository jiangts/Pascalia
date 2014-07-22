(function() {
  var Cell, Parent, Pascal, parent,
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
    function Pascal(cells) {
      this.cells = cells;
    }

    Pascal.prototype.locate = function(_level, _index) {};

    return Pascal;

  })();

  parent = new Parent({
    level: 0,
    index: 1,
    value: 1
  });

  console.log(parent);

  console.log(parent.testChild({
    index: 1,
    level: 2
  }));

}).call(this);
