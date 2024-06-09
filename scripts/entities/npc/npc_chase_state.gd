class_name NPCChaseState
extends State

@export var actor: NPC
@export var animator: AnimationPlayer
@export var vision_cast: RayCast2D

signal lost_player

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	print("chase state activate!")
	set_physics_process(true)
	animator.play("move_right")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	# TODO: face correct direction when moving towards player
	var direction = Vector2.ZERO.direction_to(actor.get_local_mouse_position()) # want actor's position and mouse's position relative to actor
	#print("direction = ", direction)
	actor.velocity = actor.velocity.move_toward(direction * actor.max_speed, 
		actor.acceleration * delta) # move velocity toward mouse w/ acceleration
	actor.move_and_slide()
	if vision_cast.is_colliding(): # if the ray is interrupted by a barrier
		# TODO: start heading towards last position of player, i.e. hunt state?, then choose direction to start searching if they're not there 
		lost_player.emit()
