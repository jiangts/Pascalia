class Cell
	constructor: (options) -> #position must be unique
		{@level, @index, @value} = options

class Parent extends Cell
	getChildren: (level) ->
		
	testChild: (position) ->
		if @index <= position.index <= (@index + position.level)
			return true
		else
			return false

class Pascal
	constructor: (@cells) ->
	
	locate: (_level, _index) ->
	
#test = new Cell {level:0, index:0, value:1}
parent = new Parent {level:0, index: 1, value:1}

console.log parent
console.log parent.testChild(index: 1, level: 2)