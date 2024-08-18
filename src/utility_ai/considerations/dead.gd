extends Consideration

var is_dead := false

## Returns weight of the consideration
func evaluate() -> float:
	if is_dead: return 99.9 # Other actions not possible while dead
	return 0.0

func _on_died():
	is_dead = true

func _on_alive():
	is_dead = false
