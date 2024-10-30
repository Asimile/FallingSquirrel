extends CharacterBody2D

var GRAVITY = 50

var mouse_position
var grappling = false

@onready var pointer = $Pointer

# Code that runs at the start of the game
func _ready():
	pass

# This is code that runs every single frame
func _physics_process(delta):
	mouse_position = get_global_mouse_position()
	
	_animate(mouse_position)
	
	#Adjust for gravity
	velocity.y += GRAVITY
	
	#Handle mouse click for grapple. 
	if !grappling:
		#Player begins grapple, grappling is true
		if Input.is_action_just_pressed("click"):
			grappling = true
	else:
		#Grapple is released, grapple is false
		if Input.is_action_just_released("click"):
			grappling = false
	
	
	move_and_slide()
	
func _animate(mouse_position):
	
	# Grapple pointer points where player aims with mouse
	pointer.look_at(mouse_position)
	pointer.rotation += PI / 2
	if mouse_position.y >= position.y:
		if mouse_position.x >= position.x:
			pointer.rotation = PI / 2
		else:
			pointer.rotation = -PI / 2
