extends State
class_name Idle

@export var sprite: AnimatedSprite2D

@export var move_state: State
@export var attack_state: State
@export var run_state: State

func enter():
	super() # Plays animation
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	if get_attack_input():
		return attack_state
	if get_movement_input() != Vector2.ZERO:
		return move_state
	if Input.is_action_just_pressed("run"):
		return run_state
	return null
	
func process_physics(delta: float) -> State:
	# NOTE: possibly delete
	parent.move_and_slide() # Nothing should happen
	
	# Currently no other states to transition to here, so just return null
	return null

