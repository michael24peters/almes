# References: https://www.youtube.com/watch?v=04A7pUkhx3E
extends CharacterBody2D

@export var animation_tree: AnimationTree
@export var player: Player

@onready var los_component = $LoSComponent

signal player_exists(player: Player)

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
	if player: player_exists.emit(player)
