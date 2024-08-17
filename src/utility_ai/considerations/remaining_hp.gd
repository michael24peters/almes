extends Consideration

func _ready():
	self.parent_keys = ["npc"]
	self.data_keys = ["healthcomponent"]

## Calculates and returns percent remaining hp of NPC
func get_derived_value() -> float:
	if data.has("npc"):
		# Load in NPC hp data
		var hp = data["npc"]["healthcomponent"]["hp"]
		var MAX_HP = data["npc"]["healthcomponent"]["max_hp"]
		
		# Calculate percent remaining hp
		if MAX_HP > 0: return hp / MAX_HP
	
	return 0.0
