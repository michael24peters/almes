extends Data
class_name LocationComponent

var location: Dictionary = {}

## Updates position every frame
func _physics_process(_delta):
	location["location"] = get_parent_position()
	# Update game_state data through emitted signal
	update_data()

## Get position of CharacterBody2D parent node
func get_parent_position() -> Vector2:
		# NOTE: Parent is immediate parent.
	var parent = get_parent()
	if parent is CharacterBody2D:
		return parent.global_position
	else:
		print("Parent is not a CharacterBody2D")
		return Vector2.ZERO

## Return location Dictionary
func get_data() -> Dictionary:
	return location
