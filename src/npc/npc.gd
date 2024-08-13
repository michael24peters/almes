# References: https://www.youtube.com/watch?v=04A7pUkhx3E
extends CharacterBody2D
class_name NPC

@export var animation_tree: AnimationTree
@export var player: Player

## TODO: using @on_ready and referencing path doesn't work
@export var tile_map: TileMap

signal player_exists(player: Player)

# Context steering variable(s)
var interests: Array

func _ready():
	# Want the animation_tree to always be active (for now)
	animation_tree.active = true
	if player: player_exists.emit(player)
	print("Node path:", $"../TileMap") # Debug
	print("Node path 2:", $"../../TileMap") # Debug

## Get entities of interest (for now CharacterBody2D's, excl. self)
## NOTE: Does not update if new entities are added after game start
func traverse_tree(node):
	# Loop through all children of Game scene
	for child in node.get_children():
		if child is CharacterBody2D and child != self:
			interests.push_back(child)
		traverse_tree(child) # Traverse sub-tree

func get_interests() -> Array:
	traverse_tree(get_tree().root)
	print("final interests = ", interests)
	return interests

## Returns an Array of global coordinates for each "danger" (object) in the 
## TileMap.
# NOTE: Does not update if new entities are added after game start
func get_dangers() -> Array:
	return [] # TODO
