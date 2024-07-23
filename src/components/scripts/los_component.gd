extends Data
# Line of Sight Component
class_name LoSComponent

# Angle of line of sight
@export var angle_cone_of_vision := deg_to_rad(200.0)
# Line of sight range
@export var max_view_distance := 150.0
# Line of sight precision
@export var angle_between_rays := deg_to_rad(5.0)
var direction := Vector2.DOWN

var target: CharacterBody2D = null
var ray_to_target: RayCast2D = null

@export var entity: CharacterBody2D

# Toggle line of sight on or off, i.e. toggle rays
@export var los_active: bool = true

# Create RayCast2D in a cone
func _ready():
	generate_ray_casts()

## Creates a cone of rays from the NPC, acting as a "line of sight".
func generate_ray_casts() -> void:
	# Determine number of rays needed
	var ray_count = int(angle_cone_of_vision / angle_between_rays)
	
	for index in range(ray_count):
		var ray := RayCast2D.new()
		# Determine ray cast angle
		var angle: float = angle_between_rays * (index - ray_count / 2.0)
		# TODO: change Vector2.Down to direction NPC is facing
		ray.target_position = direction.rotated(angle) * max_view_distance
		add_child(ray)
		ray.enabled = true

func update_rays() -> void:
	# Determine number of rays needed
	var ray_count = int(angle_cone_of_vision / angle_between_rays)
	
	var index = 0
	for ray in get_children():
		if ray is RayCast2D:
			# Determine ray cast angle
			var angle: float = angle_between_rays * (index - ray_count / 2.0)
			# TODO: change Vector2.Down to direction NPC is facing
			ray.target_position = direction.rotated(angle) * max_view_distance
		index += 1

func _physics_process(delta) -> void:
	update_rays()
	# Search for Character in line of sight
	for ray in get_children():
		if ray is RayCast2D:
			# Update ray positions
			ray.global_position = entity.global_position
			
			if ray.is_colliding() and ray.get_collider() is CharacterBody2D:
				ray_to_target = ray
				target = ray.get_collider()
				# Update Database
				update_data()
				break
			else: 
				target = null
				ray_to_target = null

## Toggle line of sight
func set_los(los: bool):
	los_active = los
	for ray in get_children():
		if ray is RayCast2D:
			if los_active: ray.enabled = true
			else: ray.enabled = false
	# Update Database
	update_data()

func get_data():
	return {
		"target": target, # null means there is no target
		"ray_to_target": ray_to_target, # null means no target in line of sight
		"los_active": los_active, # true by default
		"angle_cone_of_vision": angle_cone_of_vision,
		"max_view_distance": max_view_distance,
		"angle_between_rays": angle_between_rays
	}

# Update direction based from StateMachine instructions, i.e. other states
func _on_direction_changed(new_direction: Vector2): 
	direction = new_direction
