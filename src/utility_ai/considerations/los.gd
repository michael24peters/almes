extends Consideration

## Return 1.0 if there is line of sight, else 0
func get_derived_value() -> float:
	if Database.data.has("npc"):
		if Database.data["npc"]["loscomponent"]["target"] != null: 
			return 1.0
	return 0.0
