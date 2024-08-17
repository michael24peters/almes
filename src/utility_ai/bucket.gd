# bucket.gd

extends Node
class_name Bucket

# Methods of the selection for selector() method
enum SelectionType {
	HIGHEST_UTILITY, # The highest utility action is chosen
	WEIGHTED_PROBABILITY, # Probability of selection proportional to utility
	TOP_UTILITY_PROBABILITY, # Weighted prob. of top X utility values
	PERCENTILE_PROBABILITY # Weighted prob. of actions at or above Xth percentile
}

# Chosen SelectionType for selector() method to use
@export var selection: SelectionType

# Bucket priority score between 0 and 1
@export var priority: float
# Toggle Bucket on or off
@export var is_active: bool = true

# Number of top utility values to use for the TOP_UTILITY_PROBABILITY case
@export var num_top_actions: int = 3
# Percentile range of acceptance for the PERCENTILE_PROBABILITY case
@export var percentile: float = .9

# Dictionary of action names and their utility scores
var actions: Dictionary

## Checks whether the Bucket should be active or not
func check_active():
	pass # To be implemented by Bucket instance

## Main method of Bucket. Update all actions then call on selector() to select an action.
func evaluate() -> Dictionary:
	if is_active:
		# Populate actions with action names and updated utility scores
		for child in self.get_children():
			if child is Action:
				actions[child.name.to_lower()] = child.evaluate()
		
		return selector()
	else:
		return {"name": "", "utility": 0.0}

## Selects action from Bucket based on chosen selection method.
func selector() -> Dictionary:
	match selection:
		SelectionType.HIGHEST_UTILITY:
			var highest_utility = actions.values().max()
			return {"name": actions.find_key(highest_utility), "utility": highest_utility}
		
		SelectionType.WEIGHTED_PROBABILITY:
			return get_weighted_probability(actions)
			
		SelectionType.TOP_UTILITY_PROBABILITY:
			if num_top_actions < 1: push_error("Cannot have <1 top score!") # Sanity check
			
			var top_actions: Dictionary # Stores the top X actions
			
			# Sort action utilities
			var sorted_values = actions.values()
			sorted_values.sort()
			
			if sorted_values.size() < num_top_actions: # Limit top action pool by amount available
				num_top_actions = sorted_values.size()
				push_warning("%d actions but %d top actions allowed." % [sorted_values.size(), num_top_actions])
			
			sorted_values = sorted_values.slice(-num_top_actions) # Keep only the top X utility values
			
			# Go through sorted_values array in reverse order for descending order
			for i in range(sorted_values.size() - 1, -1, -1):
				top_actions[actions.find_key(sorted_values[i])] = sorted_values[i] # Get top X utility actions
			
			# Return weighted probability on top actions
			return get_weighted_probability(top_actions)
		
		SelectionType.PERCENTILE_PROBABILITY:
			var utilities = actions.values()
			utilities.sort() # Sort the utility values in ascending order
			
			# Determine the index and value where percentile threshold is reached
			var cutoff_index = int(ceil(percentile * utilities.size())) - 1
			var percentile_value = utilities[cutoff_index] # Value closest to percentile threshold
			
			var top_actions: Dictionary = {} # Stores the top percentile actions
			
			# Find actions in percentile range
			for action in actions:
				if actions[action] >= percentile_value:
					top_actions[action] = actions[action]
			
			# Perform weighted probability selection on actions in percentile range
			return get_weighted_probability(top_actions)
		
	# Return error if no matches in switch case
	push_error("Unrecognized SelectionType: %d" % [selection])
	return {"name": "", "utility": 0.0}

## Calculates probability weights for each action based on utility value then selects an action.
func get_weighted_probability(actions_: Dictionary) -> Dictionary:
	var weighted_actions = actions_.duplicate()
	var sum = weighted_actions.values().reduce(func(accum, utility): return accum + utility)
	
	var seed = randf() # Generate a pseudo-random float in range [0,1]
	var cumulative_weight = 0.0
	
	for action in weighted_actions: 
		# Weight action utility scores. The sum of these weights is 1.
		weighted_actions[action] /= sum
		
		# Add current weight to running total
		cumulative_weight += weighted_actions[action]
		# If action weight range contains seed, selected action found
		if seed <= cumulative_weight: return {"name": action, "utility": actions_[action]}
		# If seed is greater than cumulative weight, check the next action
	
	# Return error if no actions found
	push_error("No action elements found!")
	return {"name": "", "utility": 0.0}
