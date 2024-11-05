extends RigidBody2D

#var GRAVITY = 30
var JUMP_STRENGTH = 800

var mouse_position
var hooked = false

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
	$Sprite2D.rotation = 0
	
	mouse_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click") and not hooked:
		if mouse_position.y <= position.y:
			hooked = true
			
			hookRaycast.target_position = to_local(get_global_mouse_position()) * 10
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
	elif Input.is_action_just_released("click") and hooked:
			hooked = false
			pinjoint.node_b = NodePath("")
	
	if hooked:
		line.clear_points()
		line.add_point(Vector2.ZERO)
		line.add_point(to_local(line_end.global_position))
	else:
		line.clear_points()
	
	_animate(mouse_position)
	
	# Physics code from video
	var grounded = get_contact_count()>0
	
	#if Input.is_action_pressed("retract") and hooked:
		#retract code here
		
	#basic platformer code below
	if Input.is_action_pressed("right") and (hooked):
		apply_central_impulse(Vector2.RIGHT)
		apply_central_impulse(Vector2.RIGHT)
	if Input.is_action_pressed("left") and (hooked):
		apply_central_impulse(Vector2.LEFT)
		apply_central_impulse(Vector2.LEFT)
	if Input.is_action_just_pressed("jump") and grounded:
		apply_central_impulse(Vector2.UP * 400)
	
	#move_and_slide()
	

func _animate(mouse_position):
	
	# Grapple pointer points where player aims with mouse
	pointer.look_at(mouse_position)
	pointer.rotation += PI / 2
	if mouse_position.y >= position.y:
		if mouse_position.x >= position.x:
			pointer.rotation = PI / 2
		else:
			pointer.rotation = -PI / 2
