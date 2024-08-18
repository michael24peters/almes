extends Consideration

## Calculates and returns percent remaining hp of NPC
func get_derived_value() -> float:
	if Database.data.has("npc"):
		# Load in NPC hp data
		var hp = Database.data["npc"]["healthcomponent"]["hp"]
		var MAX_HP = Database.data["npc"]["healthcomponent"]["max_hp"]
		
		# Calculate percent remaining hp
		if MAX_HP > 0: return hp / MAX_HP
	
	return 0.0
