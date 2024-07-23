@icon("res://assets/icons/StateSprite.png")
extends Node
class_name State

signal state_transition
signal direction_changed(direction: Vector2)

func enter():
	pass

func update(_delta: float):
	pass

func exit():
	pass

