extends CharacterBody2D

var GRAVITY = 30
var JUMP_STRENGTH = 800

var mouse_position
var hooked = false
var airborne = false

@onready var pointer = $Pointer
@onready var hookRaycast = $RayCast2D

@export var hook: StaticBody2D
@export var pinjoint: PinJoint2D
@onready var line = $Line2D
@onready var line_end = hook.get_node("Marker2D")

# Code that runs at the start of the game
func _ready():
	pass

# This is code that runs every single frame
func _physics_process(delta):
	mouse_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click") and not hooked:
		hooked = true
		
		hookRaycast.target_position = to_local(get_global_mouse_position())
		hookRaycast.force_raycast_update()
		if hookRaycast.is_colliding():
			# Get values from raycast
			var hook_pos = hookRaycast.get_collision_point()
			var collider = hookRaycast.get_collider()
			# If the ray collides with a hookable object, move pinjoint and hook to it
			if collider.is_in_group("Hookable"):
				pinjoint.global_position = hook_pos
				hook.global_position = hook_pos
				pinjoint.node_b = get_path_to(hook)
				# Rotate the hook so it is the right angle (If I was giving it a sprite)
				hook.rotation = (hook_pos - global_position).angle() # Where in parentheses is a direction, essentially
				
				
	
	_animate(mouse_position)
	
	#Adjust for gravity
	velocity.y += GRAVITY
	
	# Bounce Logic
	#if airborne and is_on_floor():
		#velocity.y = -velocity.y * .5
		#airborne = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_STRENGTH
		#airborne = true
		print("Jumped")
	
	
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
