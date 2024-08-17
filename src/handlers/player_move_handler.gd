extends InputHandler

@export var move_speed: float = 200.0

func want_move() -> bool:
	if Input.is_action_just_pressed("move_left"): return true
	elif Input.is_action_just_pressed("move_right"): return true
	elif Input.is_action_just_pressed("move_up"): return true
	elif Input.is_action_just_pressed("move_down"): return true
	return false

func get_direction() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")

	if input != Vector2.ZERO:
		input = input.normalized()
	
	return input

func get_move_speed() -> float:
	return move_speed
