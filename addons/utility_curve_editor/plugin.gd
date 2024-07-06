@tool
extends EditorPlugin

## To setup this plug, go to Project -> Project Settings... -> Plugins, and make
## sure to set script to plugin.gd. This will recognize this file, which will
## load the utility curve inspector, which will properly update the utility AI
## curve properties depending on curve type.

var utility_curve_inspector

func _enter_tree():
	utility_curve_inspector = preload("res://addons/utility_curve_editor/utility_curve_inspector.gd").new()
	add_inspector_plugin(utility_curve_inspector)


func _exit_tree():
	remove_inspector_plugin(utility_curve_inspector)
