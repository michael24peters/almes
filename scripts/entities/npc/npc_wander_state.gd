class_name NPCWanderState
extends State

@export var actor: NPC
@export var animator: AnimationPlayer
@export var vision_cast: RayCast2D

signal found_player

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move_right")
	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed # set direction of move to be in random direction

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta):
	# TODO: change sprite animation to direction of motion
	# TODO: this next line probably needs fixing to have more believable wandering motion
	actor.velocity = actor.velocity.move_toward(Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed, actor.acceleration * delta) # accelerate when in wander_state until at max speed
	#print("actor velocity = ", actor.velocity)
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
	if not vision_cast.is_colliding(): # If the ray is not colliding w/ mouse
		found_player.emit()
		
