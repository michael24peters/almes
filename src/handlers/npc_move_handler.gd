extends InputHandler

@export var los_component: LoSComponent

var ray_direction := Vector2.ZERO

func get_direction() -> Vector2:
	# Get direction
	if los_component.ray_to_target != null:
		ray_direction = los_component.ray_to_target.target_position
	else: ray_direction = Vector2.ZERO
	
	# Normalize direction
	if ray_direction != Vector2.ZERO:
		ray_direction = ray_direction.normalized()
	
	return ray_direction
