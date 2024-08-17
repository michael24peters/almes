# Copyright (C) 2023 John Pennycook
# SPDX-License-Identifier: MIT
@tool
extends EditorInspectorPlugin

func _can_handle(object):
	return object.has_method("_is_utility_ai_curve")

func _parse_property(
	object, _type, name, _hint_type, _hint_string, _usage_flags, _wide
):
	if object == null:
		return

	var properties_to_hide := ["min_value", "max_value"]

	if object.curve_type == UtilityAICurve.CurveType.BINARY:
		properties_to_hide += ["slope", "exponent"]
	elif object.curve_type == UtilityAICurve.CurveType.LINEAR:
		properties_to_hide += ["exponent"]
	elif object.curve_type == UtilityAICurve.CurveType.EXPONENTIAL:
		properties_to_hide += []
	elif object.curve_type == UtilityAICurve.CurveType.LOGISTIC:
		properties_to_hide += []
	elif object.curve_type == UtilityAICurve.CurveType.CUSTOM:
		properties_to_hide += ["exponent", "slope", "x_shift", "y_shift"]

	if name in properties_to_hide:
		return true  # Hide the property
	
	return false  # Do not hide the property
