extends Consideration

@export var entity: CharacterBody2D

## Calculates and returns percent remaining hp of NPC
func get_derived_value() -> float:
	var entity_name = entity.name.to_lower()
	
	if data.has(entity_name):
		var hp = data[entity_name]["healthcomponent"]["hp"]
		var MAX_HP = data[entity_name]["healthcomponent"]["max_hp"]
		if MAX_HP > 0: return hp / MAX_HP
	
	return 0.0
