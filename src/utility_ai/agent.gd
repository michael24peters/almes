#agent.gd

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

extends Node
class_name Agent

@export var state_machine: StateMachine

var buckets: Dictionary
var current_bucket: Bucket

var current_action: Dictionary = {"name": "", "utility": 0.0}
signal action_changed

enum InertiaType {
	TIMER, # New action can be selected after set time
	THRESHOLD # Selected utility - current utility >= threshold to change
}

# Inertia method could be different for each action.
# This is specific to implementation and not defined here.
# Default inertia method is TIMER
@export var inertia_method : InertiaType = InertiaType.TIMER
var inertia_active: bool = false

# Timer variables
var timer_created = false
var timer: Timer # Declare timer variable here for scope

func _physics_process(_delta: float):
	# Sanity check
	if buckets.size() == 0: push_error("No buckets found!")
	
	var bucket_changed = false
	
	# Update all buckets
	for child in get_children():
		if child is Bucket:
			buckets[child.name.to_lower()] = child
		
	# Set highest priority Bucket as current Bucket
	for bucket in buckets: # Loop through Buckets
		if buckets[bucket].is_active: # Only check active Buckets
			# Set current bucket to highest priority bucket
			if current_bucket == null or buckets[bucket].priority > current_bucket.priority:
				current_bucket = buckets[bucket]
				bucket_changed = true # Changing Bucket breaks inertia

	# Update current Bucket's updated selected action
	var selected_action = current_bucket.evaluate()
	
	# Check inertia
	inertia(selected_action)
	#print("inertia: ", inertia_active) # Debug

	# Changing Bucket breaks inertia
	if bucket_changed: inertia_active = false

	if !inertia_active:
		# Emit signal if switch to new action
		if current_action["name"] != selected_action["name"]:
			action_changed.emit()
		
		#print("current action: ", current_action) # Debug
		#print("selected action: ", selected_action) # Debug
		# Update current action
		current_action = selected_action

## duration: length of timer in seconds
## threshold: current_action utility - selected_action utility >= threshold to change action
func inertia(selected_action: Dictionary, duration = 3, threshold = .1):
	inertia_active = true # Set inertia to false only if inertia is broken
	
	match inertia_method:
		
		InertiaType.TIMER:
			# Create a Timer if one doesn't exist yet
			if !timer_created:
				print("Timer created.") # Debug
				timer = Timer.new() # Create timer
				add_child(timer) # Add timer as child to Agent
				timer.wait_time = duration # Set Timer duration
				timer.one_shot = true # Prevents looping Timer
				timer.start() # Start Timer
				timer.connect("timeout", Callable(self, "_on_timer_timeout"))
				timer_created = true # Timer is now created
			
			# Check whether Timer ends
			var timer_exists = find_child("Timer", true, false) # Check if Timer running
			if !timer_exists: inertia_active = false # Inertia breaking condition (Timer ends)
		
		InertiaType.THRESHOLD:
			if selected_action["utility"] - current_action["utility"] >= threshold: inertia_active = false

## Remove inertia Timer when it ends
func _on_timer_timeout():
	var timer = get_tree().root.get_node_or_null((self.get_path() as String) + "/" + "Timer")
	if timer: timer.queue_free()
	else: push_error("No Timer found!")
