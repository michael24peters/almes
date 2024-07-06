extends Node
class_name Action

## Action is the behavior for the entity to exhibit as well as the utility score
## of exhibiting said behavior. Action logic is not managed here, only the name
## which, if selected, is passed on to the state machine and input handler for
## execution.
##
## The flow of Action is as follows:
## 1. Gather all Consideration instances and evaluate their utility scores.
## 2. Aggregate the scores by selected AggregationType.

@export var aggregation: AggregationType = AggregationType.MULT

enum AggregationType {
	MULT, # Utility scores should be multiplied together
	AVG, # Utility scores should be averaged
	SUM, # Utility scores should be added together
	MIN, # Lowest utility score should only be kept
	MAX # Highest utility score should only be kept
}

## Calculate the utility of this action.
func evaluate() -> float:
	# Add all Consideration instances to array
	var considerations: Array = []
	for child in self.get_children():
		if child is Consideration:
			considerations.push_back(child)
	
	var scores: Array[float] = []
	
	# Evaluate each consideration and store value in scores
	for consideration in considerations:
		if consideration is Consideration:
			var score = consideration.evaluate()
			scores.append(score)
	
	# Aggregate the scores
	return aggregate(scores)

## Calculate the aggregate of consideration scores according to the chosen
## aggregation method.
func aggregate(scores: Array[float]) -> float:
	match aggregation:
		AggregationType.MULT:
			return scores.reduce(func(accum, score): return accum * score)
		AggregationType.AVG:
			return scores.reduce(func(accum, score): return accum + score) / len(scores)
		AggregationType.SUM:
			return scores.reduce(func(accum, score): return accum + score)
		AggregationType.MIN:
			return scores.min()
		AggregationType.MAX:
			return scores.max()
	
	# Return error if no matches in switch case
	push_error("Unrecognized AggregationType: %d" % [aggregation])
	return 0.0
