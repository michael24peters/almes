extends State

# AnimationTree of animation logic
@export var animation_tree: AnimationTree

var direction := Vector2.ZERO # Default face downwards when game starts

func enter():
	#print("Entered Die state") # Debug
	# Activate die animation in AnimationTree
	animation_tree["parameters/conditions/die"] = true 
	# Set direction, which only needs to be defined upon entering Die state
	animation_tree["parameters/Die/blend_position"] = direction

func exit():
	# Deactivate die animation in AnimationTree
	animation_tree["parameters/conditions/die"] = false

## Update direction
func _on_direction_changed(new_direction: Vector2): 
	direction = new_direction
