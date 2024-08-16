# References: https://www.youtube.com/watch?v=04A7pUkhx3E
extends CharacterBody2D
class_name NPC

@export var animation_tree: AnimationTree
@export var player: Player

@onready var state_machine = $StateMachine
@onready var agent = $Agent

signal player_exists(player: Player)

# Need to know current direction for when we switch to a new state that needs 
# direction input from previous state(s)
var current_direction := Vector2.ZERO

# Current action as determined by utility AI
var current_action : Dictionary # NOTE: shouldn't need to set default value

# Die variable(s)
var dead := false

# Attack variable(s)
@onready var timer = $StateMachine/Attack/Timer

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
	
	if player: player_exists.emit(player)

## Translates all Actions into appropriate State(s) and InputHandler(s)
func _on_action_changed(action):
	current_action = action
	state_instructions()

func state_instructions():
	if current_action["name"] == "die":
		state_machine.change_state("die")
		dead = true
	
	if !dead:
		if current_action["name"] == "idle": 
			#print("Changing to idle state...") # Debug
			state_machine.change_state("idle")
		elif current_action["name"] == "wander": 
			#print("Changing to wander state...") # Debug
			state_machine.change_state("move")
		elif current_action["name"] == "chase": 
			#print("Changing to chase state...") # Debug
			state_machine.change_state("move")
		elif current_action["name"] == "attack":
			if timer.is_stopped():
				#print("Changing to attack state...") # Debug
				state_machine.change_state("attack")
			else: 
				#print("Changing to idle state...")
				state_machine.change_state("idle")

## Signal handler for changing movement directions. 
##
## This is used for storing previous facing direction for animations that need 
## a direction but don't themselves initiate a direction.
func _on_direction_changed(direction: Vector2):
	current_direction = direction
	# Notify all relevant states of direction change
	for state in state_machine.get_children():
		if state is State and state.has_method("_on_direction_changed"):
			state._on_direction_changed(current_direction)

func _on_attack_finished():
	timer.start()
	state_instructions()

func _on_timer_timeout():
	state_instructions()

func _on_died():
	dead = true
	state_instructions()
