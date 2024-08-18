extends Data
class_name HealthComponent

@export var MAX_HP := 1.0
var hp: float

signal died
signal alive

func _ready():
	hp = MAX_HP
	alive.emit() # Emit alive signal
	update_data()

func get_data() -> Dictionary:
	return {
		"hp": hp,
		"max_hp": MAX_HP
	}

## Reduce hp by amount. Emit dead signal if it lowers owner below 0 hp.
func damage(amount: float):
	#print("damage = ", amount) # Debug
	hp -= amount
	hp = clamp(hp, 0, MAX_HP) # Cannot go past 0 or max hp bounds
	#print("remaining hp = ", hp) # Debug
	update_data() # Emit signal of new data (incl. new hp)
	if hp == 0: 
		print("Slain!")
		died.emit() # Emit died signal

## Increase hp by amount. Emit alive signal if it raises owner above 0 hp.
func heal(amount: float):
	if hp == 0 and hp + amount > 0: alive.emit() # Emit alive signal
	damage(-amount) # negative (-) damage = healing; reduces redundant code
