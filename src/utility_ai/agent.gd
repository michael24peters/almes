extends Node
class_name Agent

## Agent decides what actions to perform.
##
## Agent:StateMachine::UtilityAI:States. The Agent is the manager of the
## Utility AI behavior, evaluating whether to perform an action based on the 
## utility scores (interpretable as the "desire" to perform or "value" of
## performing a given action).
##
## The flow of Agent is as follows:
## 1. Load all buckets.
## 2. Select the highest utility, active bucket.
## 3. Select the bucket's selected action if there is no inertia active.

# TODO: bucket_changed needs to contain the right thing in it in order to
# propagate changes in the agent

# Format: {"name": string, "utility": float}
var current_action: Dictionary = {}
var selected_action: Dictionary = {}

# Format: {"[bucketname]": Bucket}
var buckets: Dictionary = {}
# Format: {"name": string, "utility": float}
var current_bucket: Dictionary = {}

enum InertiaType {
	TIMER, # Waits for a set period of time
	SIGNIFICANCE, # Waits for a significantly better action to present itself
	FINISHED # Waits for behavior to complete
}

var inertia: bool = false
@export var inertia_type := InertiaType.TIMER
@export var inertia_duration := 1.0
@export var inertia_threshold := .1

signal bucket_changed(new_bucket)
signal action_changed(new_action)

func _ready():
	# Save buckets as string-Bucket pair
	for child in get_children():
		if child is Bucket:
			buckets[child.name.to_lower()] = child

## Bucket selection followed by action selection.
func _physics_process(delta):
	if buckets.size() == 0: push_error("No buckets found!")
	# Update current bucket
	bucket_selector()
	# Update action based on current bucket
	action_selector()

## Selects which bucket to use based on which has the highest utility score.
func bucket_selector():
	for bucket in buckets:
		# If active bucket has highest utility, switch to it so long as inertia
		# is not active
		if buckets[bucket].utility > current_bucket["utility"] and bucket.is_active and !inertia:
			# Format current_bucket to match action format
			current_bucket["name"] = bucket
			current_bucket["utility"] = buckets[bucket].utility
			bucket_changed.emit(bucket)

## Checks for and updates current action from current bucket
func action_selector():
	apply_inertia() # Check inertia
	
	# Check current_bucket's selected action
	selected_action = buckets[current_bucket["name"]].evaluate()
	
	if !inertia: # Only allow action change if inertia off
		if current_action["name"] != selected_action["name"]: # Check for change
			current_action = selected_action # Change current action
			action_changed.emit(selected_action) # Emit action change
			
			# If using TIMER for inertia and no Timer exists, create one
			if inertia_type == InertiaType.TIMER and !find_child("Timer", true, false):
				_create_timer()

## Applies inertia to an action, preventing action "stutter" where two close
## utility values are rapidly switched between, causing erratic AI behavior.
func apply_inertia():
	inertia = true
	match inertia_type:
		InertiaType.TIMER:
			# When the timer no longer exists, end inertia
			var timer = find_child("Timer", true, false)
			if !timer: inertia = false
		InertiaType.SIGNIFICANCE:
			if selected_action["utility"] - current_action["utility"] > inertia_threshold:
				inertia = false
		InertiaType.FINISHED:
			# TODO: To be implemented in the future, as animations and 
			# connection to the state machine become more clear.
			inertia = false 

func _create_timer():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = inertia_duration
	timer.one_shot = true # Prevents looping timer
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout() -> void:
	inertia = false
	var timer = get_tree().root.get_node_or_null((self.get_path() as String) + "/" + "Timer")
	if timer: timer.queue_free()
	else: push_error("No timer found!")
