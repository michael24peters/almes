@icon("res://assets/icons/FSMSprite.png")
extends Node
class_name StateMachine

@export var initial_state: State

var states: Dictionary = {}
var current_state: State
# Need to handle conflicting directions from movement and attacking
var direction_priority := 0
# Need to know current direction for when we switch to a new state that needs 
	# direction input from previous state(s)
var current_direction := Vector2.ZERO

## Populates states Dictionary with state name (string) and state node (State)
## key-value pairs.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# Allow states to communicate state status
			child.state_transition.connect(change_state)
			# Allow states to communicate direction (change)
			child.direction_changed.connect(_on_direction_changed)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

## Calls on the state's update() method every frame to check for calls to change
## states.
func _physics_process(delta):
	if current_state:
		current_state.update(delta)

## Changes from one state to another if its name is in the states Dictionary.
func change_state(source_state : State, new_state_name : String):
	if source_state != current_state:
		print("Invalid change_state(): trying to change from " 
			+ source_state.name + " but currently in: " + current_state.name)
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("new_state is empty!")
		return
		
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

## Signal handler for changing movement directions. 
##
## This is used for storing previous facing direction for animations that need 
## a direction but don't themselves initiate a direction, e.g. spaceback to 
## attack does so in the last facing direction but does not specify direction 
## independently.
func _on_direction_changed(direction: Vector2, priority: int):
	if priority >= direction_priority:
		direction_priority = priority
		current_direction = direction
		# Notify all relevant states of direction change
		for state in get_children():
			if state is State and state.has_method("_on_direction_changed"):
				state._on_direction_changed(current_direction)
