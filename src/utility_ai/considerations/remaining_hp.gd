extends Consideration

var entity: CharacterBody2D

func _ready():
	self.parent_keys = ["npc", "npc"]
	self.data_keys = ["self", "healthcomponent"]

## Calculates and returns percent remaining hp of NPC
func get_derived_value() -> float:
	if data.has("npc"):
		entity = data["npc"]["self"]
		
		var hp = data["npc"]["healthcomponent"]["hp"]
		var MAX_HP = data["npc"]["healthcomponent"]["max_hp"]
		if MAX_HP > 0: return hp / MAX_HP
	
	return 0.0
