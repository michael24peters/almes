extends InputHandler

@export var agent: Agent

func want_attack():
	if agent.current_action["name"] == "attack": return true
	return false

