extends CharacterBody2D

var GRAVITY = 50

var mouse_position

@onready var pointer = $FallingForItPointer

# Code that runs at the start of the game
func _ready():
	pass

# This is code that runs every single frame
func _physics_process(delta):
	mouse_position = get_global_mouse_position()
	
	_animate(mouse_position)
	#Adjust for gravity
	#velocity.y += GRAVITY
	
func _animate(mouse_position):
	
	# Grapple pointer points where player aims with mouse
	pointer.look_at(mouse_position)
	pointer.rotation += PI / 2
	if mouse_position.y >= position.y:
		if mouse_position.x >= position.x:
			pointer.rotation = PI / 2
		else:
			pointer.rotation = -PI / 2
