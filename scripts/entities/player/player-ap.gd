extends CharacterBody2D

@export var speed = 150.0
var direction = Vector2.ZERO
var last_direction = Vector2.DOWN  # Default direction when idle at start

@export var animation_tree: AnimationTree

@onready var window : Window = get_window()

@onready var hitbox_component = $HitboxComponent

var is_attacking = false

func _ready():
	animation_tree.active = true

# Runs at fixed 60 (default) times per second rate
func _physics_process(delta):
	handle_input()
	update_movement()
	move_and_slide()
	update_animation()
	
func handle_input():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	# Normalizes value to 1 so that diagonal movement is not faster
	if direction != Vector2.ZERO: 
		direction = direction.normalized()
		last_direction = direction

func update_movement():
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	
	if is_attacking: velocity /= 10

func update_animation():
	if is_attacking: return # Do not update animation if attacking
	
	var attack_dir = Vector2.ZERO
	
	if Input.is_action_just_pressed("swing_mouse"):
		# Get the current mouse position
		var mouse_pos = get_viewport().get_mouse_position()
		
		# Get the size of the screen
		var window_size = window.size
		
		# Map mouse position to (0,0) at top left and (1,1) at bottom right
		attack_dir = Vector2(
			(mouse_pos.x / window_size.x) * 2 - 1,
			(mouse_pos.y / window_size.y) * 2 - 1
		)
	elif Input.is_action_just_pressed("swing_button"):
		attack_dir = last_direction
	
	animation_tree.set("parameters/conditions/swing", 
		Input.is_action_just_pressed("swing_button")
		|| Input.is_action_just_pressed("swing_mouse"))
	if animation_tree["parameters/conditions/swing"]:
		is_attacking = true
		#print("is_attacking = ", is_attacking)
		animation_tree["parameters/Swing/blend_position"] = attack_dir

	# Update animation state based on velocity
	animation_tree.set("parameters/conditions/idle", direction == Vector2.ZERO)
	animation_tree.set("parameters/conditions/move", direction != Vector2.ZERO)
	
	# Set blend positions to last inputted direction
	animation_tree["parameters/Idle/blend_position"] = last_direction
	animation_tree["parameters/Move/blend_position"] = direction

func _on_AttackAnimationFinished(anim_name): if is_attacking: is_attacking = false
