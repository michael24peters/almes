extends Node
class_name Consideration

## Consideration is a decision factor used to determine the utility of an
## Action (see action.gd).
##
## The flow of Consideration is as follows:
## 1. Necessary data is requested by request_data().
## 2. GameState passes game_state_data with requested data_key to be accessed.
##    This is then stored in game_values.
## 3. The derived value is calculated by calculate_derived_values(), which is
##    the value the UtilityAICurve will use as its input.
## 4. The utility of a consideration is determined by evaluate(), the
##    UtilityAICurve, and whatever utility function the curve uses.

# Mapping from input to curve value
@export var curve: UtilityAICurve
# Whether to invert the value (i.e., by subtracting it from 1) before
# using it to calculate utility.
@export var invert: bool

# Signal to request data from GameState
signal data_requested(data_key, requester)
# Signal to notify when data is received; not currently needed
#signal data_received(data_key, data)

# Dictionary of DataNode values
var game_values: Dictionary = {}
var derived_value: float

## To be implemented in instance of Consideration class; need to determine the
## derived_value to pass into a UtilityAICurve.
func evaluate() -> float:
	# Calculate value to pass to curve
	derived_value = calculate_derived_value()
	if invert:
		derived_value = 1 - derived_value
	return curve.evaluate(derived_value)

## To be implemented in instance of Consideration class.
func calculate_derived_value() -> float:
	return 0.0

## Receieve requested data from Dictionary of data (usually GameState's 
## game_state_data variable).
func receive_data(node_key, child_key, data):
	game_values[node_key][child_key] = data
	print("Data received: %s : %s : %s", [node_key, child_key, data.to_string()]) # Debug

## To be implemented in instanced Consideration; generic implementation
## commented below.
func request_data():
	#data_requested.emit(data_key, self)
	pass
