# data.gd

extends Node
class_name Data

# Declare all data variables
# Signal to notify when data changes
signal data_changed(node_name, new_data)

## return relevant data
func get_data() -> Dictionary: 
	return {} # Returns data formatted as a Dictionary

## Notify Database of data change. Every time you change the data in an instance
## of Data, you must call this method to notify the Database.
# NOTE: an alternative is to make every variable private and require a getters
# and setters, which automatically call data_changed signal
func update_data(): 
	data_changed.emit(self.get_parent().name.to_lower(), self.name.to_lower(), get_data())
