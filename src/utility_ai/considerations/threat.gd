extends Consideration

## Calculates and returns percent remaining hp of NPC
# NOTE: excluding from considerations for now for simplest implementation
func get_derived_value() -> float:
	return 1.0
	#if Database.data.has("npc") and Database.data.has("player"):
		## Load in NPC and Player hp values
		#var entity_hp = Database.data["npc"]["healthcomponent"]["hp"]
		#var target_hp = Database.data["player"]["healthcomponent"]["hp"]
		#
		## Base derived value
		#var derived_value = 1.0
		#
		#if entity_hp and target_hp > 0: 
			## Simple ratio of hp values, clamped between 0 and 3
			#var hp_diff = clamp(entity_hp / target_hp, 0.0, 3.0)
			#
			## TODO: replace all this with a aggregate "power" score based on
			## comparing sum total of combat-related stats
			#
			## If ratio is high, threat is low
			#if hp_diff <= 1/3: derived_value *= .1
			#elif hp_diff <= 1/2: derived_value *= .25
			#elif hp_diff <= 1: derived_value *= .5
			#elif hp_diff <= 2: derived_value *= .75
			#elif hp_diff <= 3: derived_value *= 1.0
			#else: derived_value *= 0 # No threat
			#
		#return derived_value
	#
	#push_error("Failed to calculate Threat consideration!")
	#return 0.0

