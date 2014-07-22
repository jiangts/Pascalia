###
Adapted from http://fabricjs.com/stickman/
###

canvas = new fabric.Canvas 'c', selection: false
fabric.Object::originX = fabric.Object::originY = 'center'

paintCell = (left, top) ->
  c = new fabric.Text('hello world',
    left: left,
    top: top,
    fontSize: 18,
    lockMovementX: true,
    lockMovementY: true
  )
  c.hasControls = c.hasBorders = false
  return c

paintCircle = (left, top) ->
  c = new fabric.Circle(
    left: left,
    top: top,
    radius: '20',
    lockMovementX: true,
    lockMovementY: true
  )
  c.hasControls = c.hasBorders = false
  return c

canvas.add(
  paintCell 500, 500
  paintCell 102, 30
  paintCell 24, 24
  paintCell 325, 73
)
