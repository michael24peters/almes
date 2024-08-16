extends State

# AnimationTree of animation logic
@export var animation_tree: AnimationTree

@onready var input_handler = $InputHandler

var direction := Vector2.ZERO # Default face downwards when game starts

signal attack_finished

func enter():
	# Activate attack animation in AnimationTree
	animation_tree["parameters/conditions/attack"] = true 
	# Set direction, which only needs to be defined upon entering Attack state
	animation_tree["parameters/Attack/blend_position"] = direction
	#print("Entered Attack state") # Debug

func update(_delta: float):
	if input_handler.has_method("get_direction"): 
		input_handler.get_direction()
		animation_tree["parameters/Attack/blend_position"] = direction
		

func exit():
	# Deactivate attack animation in AnimationTree
	animation_tree["parameters/conditions/attack"] = false
	#print("Exited Attack state") # Debug

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
		attack_finished.emit()

