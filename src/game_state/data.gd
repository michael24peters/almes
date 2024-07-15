# data.gd

extends Node
class_name Data

# Declare all data variables
# Signal to notify when data changes
signal data_changed(node_name, new_data)

## return relevant data
func get_data() -> Dictionary: 
	return {} # Returns data formatted as a Dictionary

## Notify Database of data change
func update_data(): 
	data_changed.emit(self.get_parent().name, self.name, get_data())
