# consideration.gd

extends Node
class_name Consideration

# Weight function curve
@export var curve: UtilityAICurve
# Invert derived value passed into weight function curve
@export var invert: bool = false

## Returns weight of the consideration
func evaluate() -> float:
	if invert: return curve.evaluate(1 - get_derived_value())
	return curve.evaluate(get_derived_value())

## Calculate and return derived value
func get_derived_value() -> float:
	return 0.0 # To be implemented by Consideration instance
