###
Adapted from http://stackoverflow.com/questions/4288253/html5-canvas-100-width-height-of-viewport
###
canvas = $('#c')[0]
context = canvas.getContext '2d'

#TODO implement this crap later...
#resize the canvas to fill browser window dynamically
#window.addEventListener 'resize', resizeCanvas, false

resizeCanvas = () ->
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  ###
   Your drawings need to be inside this function otherwise they will be reset when 
   you resize the browser window and the canvas goes will be cleared.
  ###
  #drawStuff()

resizeCanvas()


#next file
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

p1 = new Parent {index: 0, value: 1}
p2 = new Parent {index: -1, value: -1}

painter = new Painter [p1, p2], 20
painter.paint()

$("#setup").click ->
  str = prompt 'Setup top row of Pascal\'s Matrix'
  cfg = eval "[#{str}]"
  parents = []
  for pair in cfg
    parents.push new Parent index:pair[0], value:pair[1]

  canvas.clear().renderAll();
  painter = new Painter parents, 20
  painter.paint()
