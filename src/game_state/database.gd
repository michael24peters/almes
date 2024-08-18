# database.gd

extends Node

var data: Dictionary

func _ready():
	traverse_tree(get_tree().root)

## Add all data to game_state. Connect data signals to Database
func traverse_tree(node):
	# Add CharacterBody2D nodes to Database
	if node is CharacterBody2D:
		# Ensure the node dictionary exists in data
		if not data.has(node.name.to_lower()):
			data[node.name.to_lower()] = {}
		
		# Add CharacterBody2D node
		data[node.name.to_lower()]["self"] = node
	
	for child in node.get_children():
	
		# Add any data from nodes which have the get_data() method
		if child.has_method("get_data"):
			# Ensure data is not already loaded in
			if not data.has(node.name.to_lower()):
				data[node.name.to_lower()] = {}
			
			# Add data
			data[node.name.to_lower()][child.name.to_lower()] = child.get_data()
			
			#print("data: ", data) # Debug
			
			# Connect data_changed signal in Data to _on_data_changed() method in Database
			child.connect("data_changed", Callable(self, "_on_data_changed"))
		
		traverse_tree(child) # Recursively check all sub-trees

## Update data when data changes
func _on_data_changed(owner_name, node_name, new_data):
	data[owner_name][node_name] = new_data
	#print("data changed: {%s, %s, %s}" % [owner_name, node_name, new_data]) # Debug
