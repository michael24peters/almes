extends State

@export var animation_tree: AnimationTree

var direction := Vector2(0,1) # Default face downwards when game starts

func enter():
	# Activate idle animation in AnimationTree
	animation_tree["parameters/conditions/idle"] = true 
	# Set direction, which only needs to be defined upon entering Idle state
	animation_tree["parameters/Idle/blend_position"] = direction
	#print("Entered Idle state") # Debug

func exit():
	# Deactivate idle animation in AnimationTree
	animation_tree["parameters/conditions/idle"] = false 
	#print("Exited Idle state") # Debug

# Update direction based from StateMachine instructions, i.e. other states
func _on_direction_changed(new_direction: Vector2): 
	direction = new_direction
