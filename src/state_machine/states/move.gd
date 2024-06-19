extends State

# InputHandlers
@export var movement_input_handler: InputHandler
# Makes the state_transition check for Attack state generic
@export var attack_input_handler: InputHandler

# AnimationTree of animation logic
@export var animation_tree: AnimationTree

# Character move speed
@export var move_speed: float

var direction := Vector2.ZERO
var last_direction := Vector2(0,1)
@export var parent: CharacterBody2D

func enter():
	# Activate move animation in AnimationTree
	animation_tree["parameters/conditions/move"] = true 

func update(delta):
	# Get direction from input handler, which has a unique instance for each 
		# character type
	var new_direction = movement_input_handler.get_direction()
	
	if new_direction != direction: # Update movement direction
		direction = new_direction
		
		# Store last direction so Move state doesn't return (0,0) when finished
		if direction != Vector2.ZERO: 
			last_direction = direction 
		# Tell state machine that direction has changed
		emit_signal("direction_changed", last_direction, 1) 
	
	if direction == Vector2.ZERO: # Enter Idle state if movement stops
		state_transition.emit(self, "Idle")
		return # Do not run the code any further
	
	# Send signal to attack if attack intent detected
	# TODO: this needs to be made generic so that *any* intention to attack
		# not just user-input, causes
	#if Input.is_action_just_pressed("attack_button") or Input.is_action_just_pressed("attack_mouse"):
		#state_transition.emit(self, "Attack")
	if attack_input_handler.want_attack() == true:
		state_transition.emit(self, "Attack")
	
	# Set animation direction
	animation_tree["parameters/Move/blend_position"] = direction 
	
	parent.velocity = direction * move_speed # Set character velocity
	parent.move_and_slide() # Move character

func exit():
	# Deactivate move animation in AnimationTree
	animation_tree["parameters/conditions/move"] = false 
