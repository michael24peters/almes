extends Consideration

func _ready():
	self.parent_keys = ["npc"]
	self.data_keys = ["loscomponent"] 

## Return 1.0 if there is line of sight, else 0
func get_derived_value() -> float:
	if data.has("npc"):
		if data["npc"]["loscomponent"]["target"] != null: 
			return 1.0
	
	return 0.0
