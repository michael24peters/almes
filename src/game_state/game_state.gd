extends Node
class_name GameState

# Dictionary to store data from all relevant nodes
var game_state_data: = {}

# Signal to request data
signal provide_data(data_key, requester)

func _ready():
	# Connect the tree_exited signal to handle node removal
	get_tree().connect("tree_exited", Callable(self, "_on_node_removed"))
	# Traverse the scene tree and register all relevant nodes
	traverse_tree(get_tree().root)
	# Connect request_data to _on_request_data method in GameState class (self)
	connect("request_data", Callable(self, "_on_request_data"))

## Traverse the scene tree and register nodes
func traverse_tree(node):
	if node is DataNode:
		register_node(node)
	for child in node.get_children():
		traverse_tree(child)

## Register a node
func register_node(node: DataNode):
	game_state_data[node.name] = node.get_data()
	node.connect("data_changed", Callable(self, "_on_data_changed"))

## Signal handler for data changes
func _on_data_changed(node_name, data):
	game_state_data[node_name] = data

## Signal handler for removing node
func _on_node_removed(node):
	if node is DataNode and node.name in game_state_data:
		game_state_data.erase(node.name)

# Signal handler for data requests
func _on_request_data(data_key, requester):
	if data_key in game_state_data:
		# Requester (usually DataNode) must be able to handle data getting
		# passed down to it.
		if requester.has_method("receieve_data"):
			emit_signal("provide_data", data_key, game_state_data[data_key], requester)
		else: push_error("Data requester has no receive_data() method!")
