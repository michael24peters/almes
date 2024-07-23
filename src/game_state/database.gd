# database.gd

extends Node
class_name Database

var game_state: Dictionary

func _ready():
	traverse_tree(get_tree().root)

## Add all data to game_state. Connect data signals to Database
func traverse_tree(node):
	for child in node.get_children():
	
		if child is Data:
			
			#print("node name: ", node.name.to_lower()) # Debug
			#print("child name: ", child.name.to_lower()) # Debug
			#print("child data: ", child.get_data()) # Debug
			
			# Ensure the node dictionary exists in game_state
			if not game_state.has(node.name.to_lower()):
				game_state[node.name.to_lower()] = {}
			
			# Add data
			game_state[node.name.to_lower()][child.name.to_lower()] = child.get_data()
			
			#print("game state: ", game_state) # Debug
			
			# Connect data_changed signal in Data to _on_data_changed() method in Database
			child.connect("data_changed", Callable(self, "_on_data_changed"))
		
		elif child is Consideration:
			# Connect request_data signal in Consideration to _on_request_data() method in Database
			child.connect("data_request", Callable(self, "_on_request_data"))
		
		traverse_tree(child) # Recursively check all sub-trees

## Update game_state when data changes
func _on_data_changed(node_name, child_name, data):
	game_state[node_name][child_name] = data

func _on_request_data(node_key, child_key, requester):
	# Check game_state has requested data
	if node_key in game_state:
		if child_key in game_state[node_key]:
			if requester.has_method("receive_data"): # Check requester can receive data 
				requester.receive_data(node_key, child_key, game_state[node_key][child_key]) # Send data
