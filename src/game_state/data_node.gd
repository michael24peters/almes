extends Node
class_name DataNode

# Signal to notify when data changes
signal data_changed(node_name, data)

# Function to get the data from the node
func get_data() -> Dictionary:
	# Override this function in child classes to return the relevant data
	# NOTE: data names should always be in snake_case
	return {}

# Function to update the data
func update_data(new_data: Dictionary):
	# Update the data (override this in child classes as needed)
	# Emit the signal to notify the game state node
	emit_signal("data_changed", self.name, new_data)

