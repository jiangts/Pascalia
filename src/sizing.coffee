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

