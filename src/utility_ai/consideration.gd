# consideration.gd

extends Node
class_name Consideration

# Weight function curve
@export var curve: UtilityAICurve

# Signal to request data from Database
signal data_request(parent_key, data_key, requester)

var data: Dictionary
var parent_keys: Array
var data_keys: Array

## Returns weight of the consideration
func evaluate() -> float:
	request_data()
	return curve.evaluate(get_derived_value())

## Calculate and return derived value
func get_derived_value() -> float:
	return 0.0 # To be implemented by Consideration instance

## Request data from Database
func request_data():
	# parent_keys and data_keys must be the same size
	if parent_keys.size() != data_keys.size():
		push_error("Index mismatch! (parent_key.size = %s, data_key.size = %s)" % [parent_keys.size(), data_keys.size()])
	for i in range(parent_keys.size()):
		data_request.emit(parent_keys[i], data_keys[i], self)

## Receive data from Database
func receive_data(parent_key, data_key, new_data):
	data[parent_key][data_key] = new_data
