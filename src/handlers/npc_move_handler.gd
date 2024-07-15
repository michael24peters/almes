extends InputHandler

var ray_direction := Vector2.ZERO

func get_direction() -> Vector2:
	var ray_direction := Vector2.ZERO
	# Get x direction
	ray_direction.x = Input.get_axis("move_left", "move_right")
	# Get y direction
	ray_direction.y = Input.get_axis("move_up", "move_down")

	if ray_direction != Vector2.ZERO:
		ray_direction = ray_direction.normalized()
	
	return ray_direction

func _on_sees_player(ray: RayCast2D):
	ray_direction = ray.position
