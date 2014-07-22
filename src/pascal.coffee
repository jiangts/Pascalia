##
# We want to
# 1. define the parents
# 2. add their children to Pascal
# 3. fill in any logical missing cells
# 4. tell Pascal to iterate through the cells and calculate their values
# 
# 5. tell Pascal to paint the screen
##

class Cell
  #uniqueness of position governed by Pascal 
  constructor: (options) ->
    {@level, @index, @value} = options

class Parent extends Cell
  constructor: (options) ->
    options.level ?= 0
    if not options.value
      console.log "parent must have initial value!"
      return false
    super options

  getChildren: (level) ->
    out = []
    for lev in [(@level + 1)..(@level + level)]
      for idx in [0..Math.abs(@level - lev)]
        out.push {level: lev, index: @index+idx, value: 0}
    return out
    
  hasChild: (position) ->
    if @index <= position.index <= (@index + position.level)
      return true
    else
      return false

class Pascal
  constructor: () ->
    @cells = []
    @parents = []

  addCell: (cell) -> #single cell
    if not @hasCell cell
      @cells.push cell
      if cell instanceof Parent
        @parents.push cell
      return cell
    else
      console.log "cell already exists"
      return false

  addCells: (cells) -> #cell array
    @addCell cell for cell in cells

  #checks for duplicate cell
  hasCell: (cell) ->
    if @locate cell.level, cell.index then true else false

  locate: (_level, _index) ->
    c = cell for cell in @cells when cell.level is _level and cell.index is _index
    out = c ? null
    return out

  populate: (level) ->
    @addCells parent.getChildren level for parent in @parents


p1 = new Parent {level:0, index: 0, value: 1}
p2 = new Parent {index: -1, value: -1}
pascal = new Pascal

pascal.addCells [p1, p2]
pascal.populate 3
console.log pascal.cells
