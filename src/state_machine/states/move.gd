extends State

# AnimationTree of animation logic
@export var animation_tree: AnimationTree

# InputHandlers
@onready var input_handler = $InputHandler

# Character move speed
var move_speed: float

var direction := Vector2.ZERO
var last_direction := Vector2(0,1)
@onready var parent : CharacterBody2D = $"../.."

signal direction_changed(last_direction: Vector2)

func enter():
	# Activate move animation in AnimationTree
	animation_tree["parameters/conditions/move"] = true 
	print("Entered Move state") # Debug

func update(delta):
	# Get direction from input handler, which has a unique instance for each 
		# character type
	var new_direction = input_handler.get_direction()
	move_speed = input_handler.get_move_speed()
	
	if new_direction != direction: # Update movement direction
		direction = new_direction
		
		# Store last direction so Move state doesn't return (0,0) when finished
		if direction != Vector2.ZERO: 
			last_direction = direction 
		# Tell state machine that direction has changed
		direction_changed.emit(last_direction)
	
	if direction == Vector2.ZERO: # Enter Idle state if movement stops
		direction_changed.emit(Vector2.ZERO) # Not moving
		return # Do not run the code any further
	
	# Set animation direction
	animation_tree["parameters/Move/blend_position"] = direction 
	
	# Get steering momentum
	#var momentum = parent.velocity - direction * move_speed
	# Get new velocity based on steering momentum
	#parent.velocity += momentum * delta
	parent.velocity = direction * move_speed # Set character velocity
	parent.move_and_slide() # Move character

func exit():
	# Deactivate move animation in AnimationTree
	animation_tree["parameters/conditions/move"] = false 
	#if parent.name.to_lower() == "npc": print("Exited Move state") # Debug
