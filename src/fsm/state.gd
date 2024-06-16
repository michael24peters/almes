@icon("res://assets/icons/StateSprite.png")
class_name State
extends Node

@export var animation_name: String
@export var move_speed: float = 200 
# Consistent gravity across all states
#var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Hold reference to Player so it can be directly controlled by the state
var parent: CharacterBody2D # NOTE: possibly change to Character
var animations: AnimatedSprite2D # Don't assume that the Character has an AS2D
var move_component
var attack_component

func enter() -> void:
	animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null # null returned means do not change states (default)

func process_physics(delta: float) -> State:
	return null # null returned means do not change states (default)

func process_frame(delta: float) -> State:
	return null # null returned means do not change states (default)

func get_movement_input() -> Vector2:
	# using components
	return move_component.get_movement_direction()

func get_attack_input() -> bool:
	return attack_component.wants_attack()

