# References: https://www.youtube.com/watch?v=04A7pUkhx3E
extends CharacterBody2D

@export var animation_tree: AnimationTree
@export var player: Player

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
	for child in get_children():
		if child is LoSComponent:
			child.player = player
