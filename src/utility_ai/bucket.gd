extends Node
class_name Bucket

##
## NOTE: The Bucket class treats the actions Dictionary destructively, i.e.
## removes actions as it searches for the action to execute. 
## NOTE: The terms "top" and "highest" are used interchangably, with preference
## to "highest" unless the code becomes unnecessarily cumbersome to interpret.
##

enum SelectionType {
	HIGHEST_SCORE, # The highest utility action is chosen
	WEIGHTED_PROB, # Chosen by weighted probability rescaled utility scores
	PERCENTILE_PROB, # Chosen by weighted prob. of top percentile scores
	TOP_SCORES_PROB # Chosen by weighted prob. of top X scores
}

@export var selection: SelectionType = SelectionType.PERCENTILE_PROB

## The utility of a bucket is based on manual input and a switch.
@export var utility := 0.0
@export var is_active := true

# Variable to store the original utility value. Acts as a backup for the utility
# value if the bucket is set to inactive.
var original_utility := 0.0

func _ready():
	# Store initial value of utility to backup
	original_utility = utility

## Set whether the bucket is active or not.
func set_is_active(value: bool):
	is_active = value
	if is_active:
		# Restore the original utility value
		utility = original_utility
	else:
		# Save the current utility and set it to 0
		original_utility = utility
		utility = 0.0

## Set the utility value of the bucket.
func set_utility(new_utility: float):
	# Check whether utility score is positive
	if new_utility >= 0.0:
		# Check whether is_active is set to true; return error otherwise
		if is_active:
			# Update the utility
			utility = new_utility
			# Update the original utility
			original_utility = new_utility
		else: push_error("Bucket is currently inactive!")
	else: push_error("Utility score must be positive. You entered %d" % 
		[new_utility])

## Determine the bucket's selected action. Unlike previous evaluate() methods 
## further in the Utility AI hierarchy, this method returns a Dictionary 
## containing the selected action and its utility score. This is for the Agent's 
## reference in connecting the selected action to the state machine.
func evaluate() -> Dictionary:
	var actions = self.get_children()
	
	# Poorly named; new_actions is actions with updated scores (via evaluate())
	var new_actions: Dictionary
	# Loop through actions
	for action in actions:
		# Evaluate action (update action and its utility)
		var score = action.evaluate()
		# Store action and utility in new_actions
		new_actions[action.name] = score
	
	# Aggregate the scores and select the action
	return selector(new_actions, selection)

## Select an action based on selection method
func selector(actions: Dictionary, selection: SelectionType, 
	percentile = .1, num_top_scores = 3) -> Dictionary:
	
	# Base return for no actions
	if actions.size() == 0: return {"name": "", "utility": 0}
	
	match selection:
		SelectionType.HIGHEST_SCORE:
			var highest_score = actions.values().max()
			return {"name": actions.find_key(highest_score), 
					"utility": highest_score}
		
		SelectionType.WEIGHTED_PROB:
			# Get action weights
			actions = get_weights(actions)
			# Choose random action based on weights
			return choose(actions.keys(), actions.values())
		
		SelectionType.PERCENTILE_PROB:
			# Get highest scoring action
			var highest_scoring_action = selector(actions, 
				SelectionType.HIGHEST_SCORE)
				
			# Find action (scores) within percentile of highest scoring action
			for action in actions:
				if highest_scoring_action["utility"] - actions[action] > percentile:
					actions.erase(action)
			
			# Return randomly chosen, top percentile action based on weights
			return selector(actions, SelectionType.WEIGHTED_PROB)
			
		SelectionType.TOP_SCORES_PROB:
			if num_top_scores < 1:
				push_error("Cannot have less than 1 top score!")
			
			var top_actions: Dictionary = {}
			
			for i in range(num_top_scores):
				# Find top scoring action in actions
				var top_action = selector(actions, SelectionType.HIGHEST_SCORE)
				
				# Add next top scoring action
				# NOTE: this looks pretty jank but it works ok?
				top_actions[top_action["name"]] = top_action["utility"]
				
				# Remove from actions, start search again
				actions.erase(top_action["name"])
			
			# Return randomly chosen, top scoring action based on weights
			return selector(top_actions, SelectionType.WEIGHTED_PROB)
	
	# Return error if no matches in switch case
	push_error("Unrecognized SelectionType: %d" % [selection])
	return {"name": "", "utility": 0}

## Calculates the appropriate weights for all actions given their utility score.
func get_weights(actions: Dictionary) -> Dictionary:
	var total_score = 0.0
	var scores = actions.values()
	# Calculate sum of action utility scores
	for score in scores: total_score += score
	
	# Divide all action scores by the total score to get action weights.
	# actions now contains elements and weights
	for action in actions: actions[action] /= total_score
	
	return actions

## Randomly selects a weight from keys (elements) and values (weights).
func choose(elements: Array, weights: Array) -> Dictionary: 
	var sseed = randf() # random uniform distributed number
	var cumulative_weight = 0.0
	for i in range(weights.size()): # for each weight we calculate cumulatives
		cumulative_weight += weights[i]
		if sseed <= cumulative_weight: # choose element
			return {"name": elements[i], "utility": weights[i]}
	push_error("No elements for choose() to choose from!")
	return {"name": "", "utility": 0}
