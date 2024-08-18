# consideration.gd

extends Node
class_name Consideration

# Weight function curve
@export var curve: UtilityAICurve
# Invert derived value passed into weight function curve
@export var invert: bool = false

# Signal to request data from Database
signal data_request(parent_key, data_key, requester)

var data: Dictionary

# To be implemented by Consideration instance
var parent_keys: Array[String]
var data_keys: Array[String]

## Returns weight of the consideration
func evaluate() -> float:
	request_data()
	if invert: return curve.evaluate(1 - get_derived_value())
	return curve.evaluate(get_derived_value())

## Calculate and return derived value
func get_derived_value() -> float:
	return 0.0 # To be implemented by Consideration instance

## Request data from Database
func request_data():
	# parent_keys and data_keys must not be empty
	#if parent_keys.size() == 0 or data_keys.size() == 0:
		#push_error("No data request for consideration! (parent_keys.size = %s, data_keys.size = %s)" % [parent_keys.size(), data_keys.size()])
	# parent_keys and data_keys must be the same size
	if parent_keys.size() != data_keys.size():
		push_error("Data request keys size do not match! (parent_keys.size = %s, data_keys.size = %s)" % [parent_keys.size(), data_keys.size()])
	
	for i in range(parent_keys.size()):
		data_request.emit(parent_keys[i], data_keys[i], self)

## Receive data from Database
func receive_data(parent_key, data_key, new_data):
	#print("\nData received: \n%s\n%s\n%s\n\n" % [parent_key, data_key, new_data]) # Debug
	
	# Ensure the node dictionary exists in data
	if not data.has(parent_key):
		data[parent_key] = {}
	
	data[parent_key][data_key] = new_data
