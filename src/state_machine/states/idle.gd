extends State

@export var animation_tree: AnimationTree

# InputHandlers
@export var movement_input_handler: InputHandler
# Makes the state_transition check for Attack state generic
@export var attack_input_handler: InputHandler

var direction := Vector2(0,1) # Default face downwards when game starts

func enter():
	# Activate idle animation in AnimationTree
	animation_tree["parameters/conditions/idle"] = true 
	# Set direction, which only needs to be defined upon entering Idle state
	animation_tree["parameters/Idle/blend_position"] = direction
	#print("Entered Idle state")

func update(_delta: float): # TODO: intent to act vs acting distinction
	# Send signal to move if movement keys detected
	if movement_input_handler.want_move():
		state_transition.emit("Move")
	
	# Send signal to attack if attack keys detected
	if attack_input_handler.want_attack() == true:
		state_transition.emit("Attack")

func exit():
	# Deactivate idle animation in AnimationTree
	animation_tree["parameters/conditions/idle"] = false 
	#print("Exited Idle state")

# Update direction based from StateMachine instructions, i.e. other states
func _on_direction_changed(new_direction: Vector2): 
	direction = new_direction
