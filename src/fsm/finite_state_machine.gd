@icon("res://assets/icons/FSMSprite.png")
extends Node
class_name FiniteStateMachine

@export var initial_state: State
var current_state: State

# NOTE: possibly change to Character
# TODO: AnimatedSprite2D -> AnimationPlayer2D
func init(parent: CharacterBody2D, animations: AnimatedSprite2D, 
	move_component, attack_component) -> void:
	for child in get_children(): # For each node holding state in the fsm tree
		if child is State:
			child.parent = parent
			child.animations = animations
			child.move_component = move_component
			child.attack_component = attack_component
	change_state(initial_state) # Initialize to default state

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
