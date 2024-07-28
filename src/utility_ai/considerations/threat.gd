extends Consideration

var entity: CharacterBody2D
var target: CharacterBody2D

func _ready():
	self.parent_keys = ["npc", "player", "npc", "player"]
	self.data_keys = ["self", "self", "healthcomponent", "healthcomponent"]

## Calculates and returns percent remaining hp of NPC
func get_derived_value() -> float:
	if data.has("npc") and data.has("player"):
		# Load in NPC and Player
		entity = data["npc"]["self"]
		target = data["player"]["self"]
		
		var derived_value = 1.0
		var entity_hp = data["npc"]["healthcomponent"]["hp"]
		var entity_max_hp = data["npc"]["healthcomponent"]["max_hp"]
		var target_hp = data["player"]["healthcomponent"]["hp"]
		var target_max_hp = data["player"]["healthcomponent"]["max_hp"]
		
		if entity_max_hp and target_max_hp > 0: 
			# Current "power" ratio
			var hp_diff = clamp(entity_hp / target_hp, 0.0, 3.0)
			# General "power" ratio
			var max_hp_diff = clamp(entity_max_hp / target_max_hp, 0.0, 3.0)
			
			# TODO: replace all this with a aggregate "power" score based on
			# comparing sum total of combat-related stats
			
			# If ratio is high, threat is low
			if hp_diff <= 1/3: derived_value *= 1.0
			elif hp_diff <= 1/2: derived_value *= .75
			elif hp_diff <= 1: derived_value *= .5
			elif hp_diff <= 2: derived_value *= .25
			elif hp_diff <= 3: derived_value *= .1
			else: derived_value *= 0 # No threat
			
			# If ratio is high, threat is low
			if max_hp_diff <= 1/3: derived_value *= 1.0
			elif hp_diff <= 1/2: derived_value *= .75
			elif hp_diff <= 1: derived_value *= .5
			elif hp_diff <= 2: derived_value *= .25
			elif hp_diff <= 3: derived_value *= .1
			else: derived_value *= 0 # No threat
			
			return derived_value
	
	push_error("Failed to calculate Threat consideration!")
	return 0.0

