extends State
class_name Move

@export var idle_state: State
@export var attack_state: State
@export var run_state: State

func process_input(event: InputEvent) -> State:
	if get_attack_input():
		return attack_state
	if Input.is_action_just_pressed("dash"):
		return run_state
	return null

func process_physics(delta: float) -> State:
	var movement = get_movement_input().normalized() * move_speed
	
	if movement == Vector2.ZERO: # Idle state condition
		return idle_state
	
	parent.velocity = movement
	parent.move_and_slide()
	
	return null
