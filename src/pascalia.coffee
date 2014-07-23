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

#next file
###
Adapted from http://fabricjs.com/stickman/
###

class Painter extends Pascal
  constructor: (parents, depth, @sep = 40) ->
    super()
    @addCells parents
    @populate depth
    @calculate()

  paint: ->
    for cell in @cells
      canvas.add @createCell cell
    #@resizeCells()
    canvas.renderAll()
      
  createCell: (cell) ->
    value = cell.value.toString()
    left = canvas.width/2 - ((cell.level - 2 * cell.index) * @sep/Math.sqrt 3)
    top = (cell.level + 1) * @sep
    #console.log "level is #{cell.level}, index is #{cell.index}, left is #{left}, top is #{top}"
    return @paintCell value, left, top

  paintCell: (value, left, top) ->
    switch
      when value < 0 then color = 'red'
      when value > 0 then color = 'green'
      else color = 'blue'
    c = new fabric.Text(value,
      left: left,
      top: top,
      fill: color,
      fontSize: 20,
      lockMovementX: true,
      lockMovementY: true
    )
    c.hasControls = c.hasBorders = false
    return c

  resizeCells: ->
    cell.scaleToWidth @sep for cell in canvas.getObjects()

canvas = new fabric.Canvas 'c', selection: false
fabric.Object::originX = fabric.Object::originY = 'center'

p1 = new Parent {index: 1, value: 1}
p2 = new Parent {index: 0, value: -3}
p3 = new Parent {index: -1, value: 2}

painter = new Painter [p1, p2, p3], 20
painter.paint()


#canvas = new fabric.Canvas 'c', selection: false
#fabric.Object::originX = fabric.Object::originY = 'center'
#
#paintCell = (left, top) ->
#  c = new fabric.Text('0',
#    left: left,
#    top: top,
#    fontSize: 20,
#    lockMovementX: true,
#    lockMovementY: true
#  )
#  c.hasControls = c.hasBorders = false
#  return c
#
#canvas.add(
#  paintCell 100, 100
#  paintCell 102, 30
#  paintCell 24, 24
#  paintCell 325, 73
#)
#
#window.c = canvas
##window.c.getObjects();
##window.c.renderAll();
##scaleToWidth(50)
