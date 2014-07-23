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
