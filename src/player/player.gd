extends CharacterBody2D
class_name Player

@export var animation_tree: AnimationTree

@onready var state_machine = $StateMachine

@export var move_handler : InputHandler
@export var attack_handler : InputHandler

# Need to know current direction for when we switch to a new state that needs 
	# direction input from previous state(s)
var current_direction := Vector2.ZERO

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true

func _physics_process(_delta: float):
	state_instructions()

## Signal handler for changing movement directions. 
##
## This is used for storing previous facing direction for animations that need 
## a direction but don't themselves initiate a direction.
func _on_direction_changed(direction: Vector2):
	current_direction = direction
	# Notify all relevant states of direction change
	for state in state_machine.get_children():
		if direction != Vector2.ZERO: # Preserve last direction moved
			if state is State and state.has_method("_on_direction_changed"):
				state._on_direction_changed(current_direction)

## Translates all Actions into appropriate State(s) and InputHandler(s)
func state_instructions():
	var current_state = state_machine.current_state.name.to_lower()
	if current_state == "idle":
		if attack_handler.want_attack(): state_machine.change_state("attack")
		elif move_handler.want_move(): state_machine.change_state("move")
	elif current_state == "move":
		if attack_handler.want_attack(): state_machine.change_state("attack")
		elif current_direction == Vector2.ZERO: 
			state_machine.change_state("idle")

func _on_attack_finished():
	state_machine.change_state("idle")
