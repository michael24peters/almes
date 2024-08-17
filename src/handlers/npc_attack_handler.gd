extends InputHandler

@export var agent: Agent
@export var los_component: LoSComponent

signal direction_changed

func want_attack():
	if agent.current_action["name"] == "attack": return true
	return false

func get_direction():
	var direction = Vector2.ZERO
	if los_component.ray_to_target != null:
		direction = los_component.ray_to_target.target_position
		direction = direction.normalized()
	direction_changed.emit(direction)
