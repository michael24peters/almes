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
# NOTE: Does not update if new entities are added after game start
func traverse_tree(node):
	# Loop through all children of Game scene
	# NOTE: This will ignore any CharacterBody2D nodes that are not direct
	# descendents of Game scene.
	for child in node.get_children():
		if child is CharacterBody2D and child != self:
			print("found interest!")
			print("child = ", child)
			interests.push_back(child)
			print("interests = ", interests)
	
		traverse_tree(child)

func get_interests():
	traverse_tree(get_tree().root)
	print("final interests = ", interests)
	return interests

## Returns an Array of global coordinates for each "danger" (object) in the 
## TileMap.
# NOTE: Does not update if new entities are added after game start
func get_dangers() -> Array:
	# Array of everything the NPC wants to stay away from
	var dangers: Array = []
	
	# Set collision layer to 5 (objects)
	var target_collision_layer = (1 << 4)

	# Get TileMap coordsall used cells in the "Objects" layer, which contains 
	# all obstacles; used_cells is of type Vector2i[]
	var used_cells = tile_map.get_used_cells(0)
	
	for cell in used_cells:
		# Convert tile coordinates to local coordinates
		var local_position = tile_map.map_to_local(cell)
		var global_position = tile_map.to_global(local_position)
		dangers.push_back(global_position)
	
	return dangers
