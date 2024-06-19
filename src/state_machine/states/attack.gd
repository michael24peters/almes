extends State

# InputHandlers
@export var movement_input_handler: InputHandler
# Makes the state_transition check for Attack state generic
@export var attack_input_handler: InputHandler

# AnimationTree of animation logic
@export var animation_tree: AnimationTree

var direction := Vector2.ZERO # Default face downwards when game starts

func enter():
	# Activate attack animation in AnimationTree
	animation_tree["parameters/conditions/attack"] = true 
	# Set direction, which only needs to be defined upon entering Attack state
	animation_tree["parameters/Attack/blend_position"] = direction

func exit():
	# Deactivate attack animation in AnimationTree
	animation_tree["parameters/conditions/attack"] = false

# Update direction based from StateMachine instructions, i.e. other states
func _on_direction_changed(new_direction: Vector2): 
	direction = new_direction

# Handle animation finished signal
func _on_animation_finished(animation_name: StringName):
	# TODO: attack animations currently use name "swing_{direction}". This is
		# a bit of hardcoding that will probably need to get solved later down
		# the road. For now, everything swings so it's fine. Probably best to 
		# give *all attacks* the name "attack" if its some kind of attack
		# e.g. "attack_swing_down_right", "attack_bow_left", etc.
	if animation_name.begins_with("swing"):
		state_transition.emit(self, "Idle")

