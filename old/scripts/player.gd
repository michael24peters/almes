extends CharacterBody2D

@export var speed = 150.0
var direction = Vector2.ZERO
var last_direction = Vector2.DOWN  # Default direction when idle at start

@onready var animated_sprite = $AnimatedSprite2D

# Runs at fixed 60 (default) times per second rate
func _physics_process(delta):
	handle_input()
	update_animation()
	move_and_slide()
	

func handle_input():
	direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	# Normalizes value to 1 so that directional movement is not faster
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	
func update_animation():
	if direction == Vector2.ZERO:
		play_idle_animation()
		return
	
	play_movement_animation()
	last_direction = direction
	
func play_idle_animation():
	if last_direction.x > 0:
		if last_direction.y > 0:
			animated_sprite.animation  = "idle_dr"
		elif last_direction.y < 0:
			animated_sprite.animation = "idle_ur"
		else:
			animated_sprite.animation = "idle_r"
	elif last_direction.x < 0:
		if last_direction.y > 0:
			animated_sprite.animation = "idle_dl"
		elif last_direction.y < 0:
			animated_sprite.animation = "idle_ul"
		else:
			animated_sprite.animation = "idle_l"
	else:
		if last_direction.y > 0:
			animated_sprite.animation = "idle_d"
		elif last_direction.y < 0:
			animated_sprite.animation = "idle_u"
			
	animated_sprite.play()
			
func play_movement_animation():
	if direction.x > 0:
		if direction.y < 0:
			animated_sprite.animation = "up_right"
		elif direction.y > 0:
			animated_sprite.animation = "down_right"
		else:
			animated_sprite.animation = "right"
	elif direction.x < 0:
		if direction.y < 0:
			animated_sprite.animation = "up_left"
		elif direction.y > 0:
			animated_sprite.animation = "down_left"
		else:
			animated_sprite.animation = "left"
	else:
		if direction.y < 0:
			animated_sprite.animation = "up"
		elif direction.y > 0:
			animated_sprite.animation = "down"
	
	animated_sprite.play()

