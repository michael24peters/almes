extends Consideration

func _ready():
	self.parent_keys = ["npc"]
	self.data_keys = ["loscomponent"] 

func get_derived_value() -> float:
	if data.has("npc"):
		var ray_to_target = data["npc"]["loscomponent"]["ray_to_target"]
		if ray_to_target is RayCast2D: 
			var origin = ray_to_target.global_position
			var collision_point = ray_to_target.get_collision_point()
			var distance = origin.distance_to(collision_point)
			# Anything beyond 5 is beyond melee attack range
			# TODO: 5 is a totally arbitrary number
			if distance / 30.0 < 1.0: return 1.0
			
	return 0.0
