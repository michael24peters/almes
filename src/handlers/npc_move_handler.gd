extends InputHandler

# Variables to send to Move state
var direction: Vector2 = Vector2.ZERO
@export var move_speed: float = 125.0

# Chase variable(s)
@export var los_component: LoSComponent

# Wander variable(s)
var done = false

# Types of movement handled by this InputHandler
enum MOVE_TYPE {
	None,
	Wander,
	Chase
}
# Selected movement type
var move: MOVE_TYPE

var directions: Array[Vector2] # Directions for context maps

var interest_map: Array # View of everything behavior wants to move towards
var danger_map: Array # View of everything behavior wants to stay away from

var interests: Array # Objects of interest
var dangers: Array # Danger COORDINATES of interest

# TODO: Don't make this an exported variable
@export var npc: NPC # NPC to apply context steering upon

var _space_state # Only want to generate this one time

func _ready():
	# Set normalized coordinate vectors into an Array
	for i in range(-1,1):
		for j in range (-1,1):
			if i != 0 and j != 0: # Don't add null-vector
				directions.push_back(Vector2(i,j).normalized())
	
	# Get interests and dangers from NPC node
	## TODO: genericize this
	interests = npc.get_interests()
	dangers = npc.get_dangers()
	
	# Only want to generate this one time
	_space_state = npc.get_world_2d().direct_space_state # Get space state

func want_move() -> bool:
	if move == MOVE_TYPE.None: return false
	return true

func get_direction() -> Vector2:
	match move:
		# Find direction according to random seed
		MOVE_TYPE.Wander:
			if !done:
				randomize() # Seed random number generator
				var angle: float = randf_range(0.0, 2.0 * PI) # Random angle
				direction = Vector2(cos(angle), sin(angle)) # Random direction
				done = true
	
		# Find direction using context-based steering
		MOVE_TYPE.Chase:
			if los_component.ray_to_target != null:
				direction = get_context_steering()
			else: direction = Vector2.ZERO
	
	return direction

func get_move_speed() -> float:
	match move:
		MOVE_TYPE.Wander: return move_speed / 2
		MOVE_TYPE.Chase: return move_speed
	
	return move_speed

## Determine direction using context-based steering, which uses an interest map
## and danger map to find safest path to highest-value interest
func get_context_steering() -> Vector2:
	var interest_mask = (1 << 0) | (1 << 2) # collision_mask for interests
	var danger_mask = (1 << 4) # collision_mask for obstacles (Objects layer)
	
	#print("dangers = ", dangers) # Debug
	#print("interests = ", interests) # Debug
	
	# Populate maps
	interest_map = get_interest_map(interests, interest_mask)
	danger_map = get_danger_map(dangers, danger_mask)
	
	#print("interest_map = ", interest_map) # Debug
	#print("danger_map = ", danger_map) # Debug
	
	# Interest and danger maps must be the size size (or else applying danger
	# map mask to interest map will not work)
	if interest_map.size() != danger_map.size():
		push_error("Interest and danger maps must be the same size. " + 
			"interest_map.size() = %d, danger_map.size() = %d" % 
			[interest_map.size(), danger_map.size()])
	#
	#print("interest map before = ", interest_map) # Debug
	
	# Set disallowed interest map slots to 0
	for i in range(danger_map.size()):
		#print("interest map = ", interest_map) # Debug
		# Find minimum in danger map, which is the allowed slot(s) for interest map
		#print("ith = ", danger_map[i])
		#print("min = ", danger_map.min())
		if danger_map[i] != danger_map.min(): 
			#print("index = ", i)
			interest_map[i] = 0.0 # Disable index
		#else:
			#print("min found!")
			#print("interest_map[i] = ", interest_map[i])
	
	#print("interest map after = ", interest_map) # Debug
	
	# Find remaining maximium interest map value and slot
	var max = interest_map.max()
	#print("max = ", max) # Debug
	
	# TODO: calculate gradients of interest around chosen slot and estimate 
	# where they would meet, moving in that direction instead.
	
	# TODO: decrease resolution of course direction from distant targets.
	
	# Return direction of maximized interest map slot
	var max_index = interest_map.find(max)
	#print("directions[max_index] = ", directions[max_index])
	return directions[max_index]

## Calculate the interest map
## Returns an Array of weights
func get_interest_map(objects: Array, collision_mask) -> Array:
	# Initialize map
	var map: Array
	for i in range(directions.size()):
		map.append(0.0)
	
	for object in objects: # Loop through all targets
		
		# Create the PhysicsRayQueryParameters2D object
		var query = PhysicsRayQueryParameters2D.new()
		query.from = npc.global_position
		query.to = object.global_position
		query.collision_mask = collision_mask
		query.exclude = [self]
		
		# Perform the ray intersection query
		var result = _space_state.intersect_ray(query) # Intersection data
		
		#print("result = ", result) # Debug
		
		# Get distance scale factor. Further distance reduces intensity of dot
		# product result.
		var distance = npc.global_position.distance_to(object.global_position)
		#print("interest distance: ", distance) # Debug
		var distance_factor = 1.0 / (distance + 1.0)
		# TODO: add a cut-off for distance?
		
		# Populate map
		# Dot product query Ray with each coordinate direction, then scale by
		# distance factor
		for i in range(directions.size()):
			if result.has("normal"):
				#print("local coords = ", npc.to_local(result["position"])) # Debug
				var contribution = npc.global_position - result["position"]
				#print("result = ", contribution) # Debug
				contribution = contribution.normalized()
				#print("normal result = ", contribution) # Debug
				contribution = contribution.dot(directions[i])
				#print("contribution = ", contribution) # Debug
				map[i] += (contribution * distance_factor)
				#print("danger contribution = ", map[i]) # Debug
	
	#print(map) # Debug
	
	return map

## Same as get_interest_map(), except the objects Array has coordinates, not 
## Nodes
func get_danger_map(objects: Array, collision_mask) -> Array:
	# Initialize map
	var map: Array
	for i in range(directions.size()):
		map.append(0.0)
	
	for object_coord in objects: # Loop through all targets
		
		#print("npc pos = ", npc.global_position) # Debug
		#print("object pos = ", object_coord) # Debug
		#print("collision mask = ", collision_mask) # Debug
		
		#var query = npc.PhysicsRayQueryParameters2D.create(npc.global_position, 
			#object_coord,
			#collision_mask, [self]) # Cast Ray query from self to target
		#var result = npc.space_state.intersect_ray(query) # Intersection data
		
		# Create the PhysicsRayQueryParameters2D object
		var query = PhysicsRayQueryParameters2D.new()
		query.from = npc.global_position
		query.to = object_coord
		query.collision_mask = collision_mask
		query.exclude = [self]
		
		# Perform the ray intersection query
		var result = _space_state.intersect_ray(query) # Intersection data
		
		#print("result = ", result) # Debug
		
		# Get distance scale factor. Further distance reduces intensity of dot
		# product result.
		# TODO: just use result.position and get its distance. saves memory?
		var distance = npc.global_position.distance_to(object_coord)
		var distance_factor = 1.0 / (distance + 1.0)
		#print("Distance factor = ", distance_factor) # Debug
		# TODO: add a cut-off for distance?
		
		# Dot product normalized query vector with each coordinate direction,
		# then scale by distance factor
		#print("directions.size() = ", directions.size()) # Debug
		# TODO: only apply dot product to closest direction, then pad either side
		for i in range(directions.size()):
			if result.has("position"):
				#print("local coords = ", npc.to_local(result["position"])) # Debug
				var contribution = npc.global_position - result["position"]
				print("result = ", contribution) # Debug
				contribution = contribution.normalized()
				print("normal result = ", contribution) # Debug
				contribution = contribution.dot(directions[i])
				print("contribution = ", contribution) # Debug
				map[i] += (contribution * distance_factor)
				print("danger contribution = ", map[i]) # Debug
	
	return map

## Update the move type based on the current action
func _on_agent_action_changed(current_action):
	if current_action["name"] == "wander": 
		move = MOVE_TYPE.Wander
		done = false
	elif current_action["name"] == "chase": move = MOVE_TYPE.Chase
	else: move = MOVE_TYPE.None # If not a Move-type action, disallow Move state
