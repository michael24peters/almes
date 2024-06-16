extends Node

@onready var window : Window = get_window()

# Return a boolean indicating if the character wants to attack.
# This function does not decide if the player actually can attack.
func wants_attack() -> bool:
	return Input.is_action_just_pressed('attack_mouse') or Input.is_action_just_pressed('attack_button')

# NOTE: may be redundant with get_movement_direction() in move_component.gd
func get_attack_direction() -> Vector2:
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("swing_mouse"):
		# Get the current mouse position
		var mouse_pos = get_viewport().get_mouse_position()
		
		# Get the size of the screen
		var window_size = window.size
		
		# Map mouse position to (0,0) at top left and (1,1) at bottom right
		direction = Vector2(
			(mouse_pos.x / window_size.x) * 2 - 1,
			(mouse_pos.y / window_size.y) * 2 - 1
		)
	
	return direction
