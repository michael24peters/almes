extends Data
class_name HealthComponent

@export var MAX_HP := 1.0
var hp: float

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = MAX_HP
	update_data()

# Override get_data to return relevant data
func get_data() -> Dictionary:
	return {
		"hp": hp,
		"max_hp": MAX_HP
	}

func damage(amount: float):
	print("damage = ", amount)
	hp -= amount
	hp = clamp(hp, 0, MAX_HP) # Cannot go past 0 or max hp bounds
	update_data() # Emit signal of new data (incl. new hp)
	if hp == 0: 
		print("Slain!") # TODO: death mechanics
		died.emit() # Death

func heal(amount: float):
	damage(-amount) # negative (-) damage = healing; reduces redundant code
