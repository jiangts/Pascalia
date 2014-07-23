##
# We want to
# 1. define the parents
# 2. add their children to Pascal
# 3. tell Pascal to iterate through the cells and calculate their values
##

class Cell
  #uniqueness of position governed by Pascal 
  constructor: (options) ->
    options.value ?= 0
    {@level, @index, @value} = options

  choose: (a, b) ->
    #order matters here!
    if b > a or a < 0 or b < 0
      console.log "input error: a = #{a}, b = #{b}"
      return false
    if b > a - b
      b = a - b
    if b is 0
      return 1
    num = [(a - b + 1)..a].reduce (prevVal, currVal) -> return prevVal * currVal
    denom = [1..b].reduce (prevVal, currVal) -> return prevVal * currVal
    return num/denom

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
      abslev = Math.abs(@level - lev)
      for idx in [0..abslev]
        out.push new Cell { level: lev, index: @index+idx }
    return out
    
  hasChild: (cell) ->
    return @index <= cell.index <= (@index + cell.level)

class Pascal
  constructor: () ->
    @cells = []
    @parents = []

  addCell: (cell) ->
    c = @hasCell cell
    if not c
      @cells.push cell
      if cell instanceof Parent
        @parents.push cell
      return cell
    #else
    #  console.log "Cell already exists."

  addCells: (cells) ->
    @addCell cell for cell in cells

  hasCell: (cell) ->
    if @locate cell.level, cell.index then cell else false

  locate: (_level, _index) ->
    c = cell for cell in @cells when cell.level is _level and cell.index is _index
    return c ? null

  populate: (level) ->
    @addCells parent.getChildren level for parent in @parents

  calculateCell: (cell) ->
    for p in @parents
      if p.hasChild cell
        cell.value += (cell.choose Math.abs(cell.level - p.level), Math.abs(cell.index - p.index)) * p.value
    return cell.value

  calculate: ->
    for cell, i in @cells
      if cell instanceof Parent is false
        cell.value = @calculateCell cell
        @cells[i] = cell

#p1 = new Parent {index: 1, value: 1}
#p2 = new Parent {index: -1, value: -2}

#pascal = new Pascal

#pascal.addCells [p1, p2]

#pascal.populate 30
#pascal.calculate()
#console.log pascal.cells

###
Catalan Example
for i in [1..10]
  console.log pascal.calculateCell new Cell level:(2*i), index:i
###
