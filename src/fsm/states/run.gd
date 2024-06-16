extends Move
class_name Run

@export var move_state: State

@export var time_to_run := 0.5

var run_timer := 0.0
var direction := Vector2(0, 1)

func enter() -> void:
	super()
	run_timer = time_to_run

	# TODO: Check for which direction to run towards

# Just to be safe, disable any other inputs
func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	run_timer -= delta
	if run_timer <= 0.0:
		# Fall back on the default input implementation to
		# determine where to go next
		if super.get_movement_input() != Vector2.ZERO:
			return move_state
		return idle_state
	
	# At this point, run 'process_physics' in the move script as written
	return super(delta)

# Override movement inputs
func get_movement_input() -> Vector2:
	return direction
