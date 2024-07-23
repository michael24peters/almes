extends Data
# Line of Sight Component
class_name LoSComponent

# Angle of line of sight
@export var angle_cone_of_vision := deg_to_rad(25.0)
# Line of sight range
@export var max_view_distance := 150.0
# Line of sight precision
@export var angle_between_rays := deg_to_rad(5.0)
# Determine number of rays needed
var ray_count = int(angle_cone_of_vision / angle_between_rays)

var target: CharacterBody2D = null
var ray_to_target: RayCast2D = null

@onready var player: Player
@export var npc: CharacterBody2D

# Toggle line of sight on or off, i.e. toggle rays
@export var los_active: bool = true

## Create RayCast2D in a cone
func _ready():
	generate_ray_casts()

## Creates a cone of rays from the NPC, acting as a "line of sight".
func generate_ray_casts() -> void:	
	for index in range(ray_count):
		var ray := RayCast2D.new()
		# Determine ray cast angle
		var angle: float = angle_between_rays * (index - ray_count / 2.0)
		ray.global_position = npc.global_position
		ray.target_position = Vector2.DOWN.rotated(angle) * max_view_distance
		ray.collision_mask = 1 | 4 | 16
		self.add_child(ray)
		ray.enabled = true

func _physics_process(delta) -> void:
	# Points rays in direction of player
	if player:
		var direction = (player.global_position - npc.global_position).normalized()
		var index = 0
		for ray in get_children():
			var angle: float = angle_between_rays * (index - ray_count / 2.0)
			if ray is RayCast2D:
				ray.global_position = npc.global_position
				ray.target_position = direction.rotated(angle) * max_view_distance
			index += 1
	
	# Search for Character in line of sight
	for ray in get_children():
		if ray is RayCast2D:
			if ray.is_colliding() and ray.get_collider() is CharacterBody2D:
				ray_to_target = ray
				target = ray.get_collider()
				# Update Database
				break
			else: 
				target = null
				ray_to_target = null
	
	# Update Database
	update_data()

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
