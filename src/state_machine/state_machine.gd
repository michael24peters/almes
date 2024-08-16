@icon("res://assets/icons/FSMSprite.png")
extends Node
class_name StateMachine

@export var initial_state: State

var states: Dictionary = {}
var current_state: State

## Populates states Dictionary with state name (string) and state node (State)
## key-value pairs.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

## Calls on the state's update() method every frame to check for calls to 
## change states.
func _physics_process(delta):
	if current_state:
		current_state.update(delta)

## Changes from one state to another if its name is in the states Dictionary.
func change_state(new_state_name : String):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
