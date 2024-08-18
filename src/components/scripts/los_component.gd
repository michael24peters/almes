extends Data
# Line of Sight Component
class_name LoSComponent

# Angle of line of sight
@export var angle_cone_of_vision := 15
# Line of sight range
@export var max_view_distance := 150.0
# Line of sight precision
@export var angle_between_rays := 5.0

# Determine number of rays needed
var ray_count = int(angle_cone_of_vision / angle_between_rays)

var target: CharacterBody2D = null
var ray_to_target: RayCast2D = null
signal target_found(entity: CharacterBody2D, ray: RayCast2D)

# Toggle line of sight on or off, i.e. toggle rays
@export var los_active: bool = true

# Area2D and its CollisionShape2D; used to toggle ray updates
@onready var _view_area = $ViewArea
@onready var _view_area_collision = $ViewArea/CollisionShape2D


## Create a cone of rays to track Player movement
func _ready():
	# Generate rays
	generate_ray_casts()
	# Set view area to match ray distance
	_view_area_collision.shape.radius = max_view_distance

## Creates a cone of rays from the NPC, acting as a "line of sight".
func generate_ray_casts() -> void:
	for index in range(ray_count):
		# Create ray
		var ray := RayCast2D.new()
		# Determine ray cast angle
		var angle: float = deg_to_rad(angle_between_rays) * (index - ray_count / 2.0)
		# Set initial positions to origin relative to owner
		ray.global_position = owner.global_position
		ray.target_position = Vector2.DOWN.rotated(angle) * max_view_distance
		# Set collision masks with bitmap (Player, Objects, Terrain)
		ray.collision_mask = 1 << 0 | 1 << 4 | 1 << 5 # TODO: pursue when no LoS
		# Add as child to LoSComponent
		self.add_child(ray)
		# Activate ray
		ray.enabled = true

func _physics_process(_delta: float) -> void:
	var flag = false # Flag if the data changes
	
	# Update view area to follow owner
	_view_area.position = owner.global_position

	# Get bodies overlapping with the view area
	var bodies_in_area = _view_area.get_overlapping_bodies()
	var target_in_area = false

	# Check if any CharacterBody2D is in the area
	for body in bodies_in_area:
		if body is CharacterBody2D:
			target_in_area = true
			break
		
	# If no CharacterBody2D is in the view area, skip ray updates
	set_los(target_in_area)
	if !target_in_area: return
	
	# Search for Character in line of sight
	for ray in get_children():
		if ray is RayCast2D:
			# Target is any CharacterBody2D colliding with ray(s)
			if ray.is_colliding() and ray.get_collider() is CharacterBody2D:
				if target == null: flag = true # Data changed
				# Set target to identified body
				target = ray.get_collider()
				# Store first colliding ray
				ray_to_target = ray
				target_found.emit(target, ray_to_target)
				break
			else: # TODO: pursue when no LoS
				if target != null : flag = true # Data changed
				target = null
				ray_to_target = null
	
	# Update Database with target information if it changed
	if flag: update_data()
	flag = false
	
	# Points rays in direction of player
	if Database.data.has("player"):
		var direction = (Database.data["player"]["self"].global_position - owner.global_position).normalized()
		var index = 0
		for ray in get_children():
			var angle: float = deg_to_rad(angle_between_rays) * (index - ray_count / 2.0)
			if ray is RayCast2D:
				if !ray.visible: ray.show()
				# Update rays to follow owner
				ray.global_position = owner.global_position
				ray.target_position = direction.rotated(angle) * max_view_distance
			index += 1

## Toggle line of sight
func set_los(los: bool):
	los_active = los
	for ray in get_children():
		if ray is RayCast2D:
			if los_active: 
				# Enable and show ray
				ray.enabled = true
				ray.show()
			else: 
				# Disable and hide ray
				ray.enabled = false
				ray.hide()
				# If rays disabled, remove all target information
				target = null
				ray_to_target = null
	# Update Database
	update_data()

func get_data():
	return {
		"target": target, # null means there is no target in line of sight
		"ray_to_target": ray_to_target, # null means there is no target in los
		"los_active": los_active, # true by default
		"angle_cone_of_vision": angle_cone_of_vision,
		"max_view_distance": max_view_distance,
		"angle_between_rays": angle_between_rays
	}
