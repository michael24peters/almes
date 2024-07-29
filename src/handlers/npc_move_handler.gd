extends InputHandler

# Variables to send to Move state
var direction: Vector2 = Vector2.ZERO
@export var move_speed: float = 125.0

# Chase variable(s)
@export var los_component: LoSComponent

# Wander variable(s)
var done = false

# Types of movement handled by this InputHandler
enum MOVE_TYPE {
	None,
	Wander,
	Chase
}
# Selected movement type
var move: MOVE_TYPE

func want_move() -> bool:
	if move == MOVE_TYPE.None: return false
	return true

func get_direction() -> Vector2:
	match move:
		MOVE_TYPE.Wander:
			if !done:
				randomize() # Seed random number generator
				var angle: float = randf_range(0.0, 2.0 * PI) # Random angle
				direction = Vector2(cos(angle), sin(angle)) # Random direction
				done = true
	
		MOVE_TYPE.Chase:
			# Get direction
			if los_component.ray_to_target != null:
				direction = los_component.ray_to_target.target_position
				direction = direction.normalized()
			else: direction = Vector2.ZERO
	
	return direction

func get_move_speed() -> float:
	match move:
		MOVE_TYPE.Wander: return move_speed / 2
		MOVE_TYPE.Chase: return move_speed
	
	return move_speed

func _on_agent_action_changed(current_action):
	if current_action["name"] == "wander": 
		move = MOVE_TYPE.Wander
		done = false
	elif current_action["name"] == "chase": move = MOVE_TYPE.Chase
	else: move = MOVE_TYPE.None # If not a Move-type action, disallow Move state
