# References: https://www.youtube.com/watch?v=04A7pUkhx3E
extends CharacterBody2D

@export var animation_tree: AnimationTree

@export var angle_cone_of_vision := deg_to_rad(30.0)
@export var max_view_distance := 200.0
@export var angle_between_rays := deg_to_rad(5.0)

var target: Player = null
signal sees_player(ray: RayCast2D)

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
	generate_ray_casts()

## Creates a cone of rays from the NPC, acting as a "line of sight".
func generate_ray_casts() -> void:
	# Determine number of rays needed
	var ray_count = int(angle_cone_of_vision / angle_between_rays)
	
	for index in range(ray_count):
		var ray := RayCast2D.new()
		# Determine ray cast angle
		var angle: float = angle_between_rays * (index - ray_count / 2.0)
		ray.target_position = Vector2.DOWN.rotated(angle) * max_view_distance
		add_child(ray)
		ray.enabled = true

func _physics_process(delta) -> void:
	for ray in get_children():
		if ray is RayCast2D:
			if ray.is_colliding() and ray.get_collider() is Player:
				target = ray.get_collider()
				sees_player.emit(ray)
				break
