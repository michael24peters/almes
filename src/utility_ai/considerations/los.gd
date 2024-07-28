extends Consideration

var entity: CharacterBody2D

func _ready():
	self.parent_keys = ["npc", "npc"]
	self.data_keys = ["self", "loscomponent"] 

## If there is line of sight, don't idle
func get_derived_value() -> float:
	if data.has("npc"):
		entity = data["npc"]["self"]
		
		if data["npc"]["loscomponent"]["target"] == null: 
			return 1.0
	
	return 0.0
