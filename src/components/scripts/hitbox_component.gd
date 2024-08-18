extends Area2D
class_name HitboxComponent

signal data_changed

@export var damage: float = 10:
	set(new_value):
		damage = new_value
		data_changed.emit(owner.name.to_lower(), self.name.to_lower(), get_data())

func get_data() -> Dictionary:
	return {
		"damage": damage
	}
