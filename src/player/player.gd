extends CharacterBody2D

@export var animation_tree: AnimationTree

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
	
