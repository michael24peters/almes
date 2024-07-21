# References: https://www.youtube.com/watch?v=04A7pUkhx3E
extends CharacterBody2D

@export var animation_tree: AnimationTree

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
