extends InputHandler

func want_attack() -> bool:
	if Input.is_action_just_pressed("attack_button"):
		return true
	return false
