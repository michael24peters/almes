extends Consideration

## If there is line of sight, return 0, else return 1
func get_derived_value() -> float:
	if data.has("npc"):
		if data["npc"]["loscomponent"]["target"] != null: 
			#print("Target acquired!") # Debug
			return 1.0
	
	#print("No target!") # Debug
	return 0.0
