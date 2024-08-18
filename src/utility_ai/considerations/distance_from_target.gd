extends Consideration

func get_derived_value() -> float:
	if Database.data.has("npc"):
		var ray_to_target = Database.data["npc"]["loscomponent"]["ray_to_target"]
		if ray_to_target is RayCast2D: 
			var origin = ray_to_target.global_position
			var collision_point = ray_to_target.get_collision_point()
			var distance = origin.distance_to(collision_point)
			# Anything beyond 1000 is beyond chase-worthy
			#print("distance = ", distance) # Debug
			return clamp(1.0 - distance / 1000.0, 0.0, 1.0)
			
	return 0.0
