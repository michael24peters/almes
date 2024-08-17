extends InputHandler

# Move speed to send to Move state
@export var move_speed: float = 125.0

var directions: Array[Vector2] # Directions for maps

var interest_map: Array # View of everything behavior wants to move towards
var danger_map: Array # View of everything behavior wants to stay away from

var interests: Array # Objects of interest
var dangers: Array # Danger COORDINATES of interest

@export var npc = self.owner # NPC to apply context steering upon

func _ready():
	print("npc: ", npc) # Debug
	# Set normalized coordinate vectors into an Array
	directions.push_back(Vector2(0,-1)) # N
	directions.push_back(Vector2(1,-1).normalized()) # NE
	directions.push_back(Vector2(1,0)) # E
	directions.push_back(Vector2(1,1).normalized()) # SE
	directions.push_back(Vector2(0,1).normalized()) # S
	directions.push_back(Vector2(-1,1).normalized()) # SW
	directions.push_back(Vector2(-1,0)) # W
	directions.push_back(Vector2(-1,-1).normalized()) # NW

func get_move_speed() -> float:
	return move_speed

# TODO: allow multiple interest and dangers maps which are combined into one
# before direction is applied.
func get_direction() -> Vector2:
	return get_context_steering()
	
func get_context_steering() -> Vector2:
	var interest_mask = (1 << 0) | (1 << 2) # collision_mask for interests
	var danger_mask = (1 << 4) # collision_mask for obstacles (objects layer)
	
	# Populate maps
	interest_map = get_interest_map(interests, interest_mask)
	danger_map = get_danger_map(dangers, danger_mask)
	
	# Interest and danger maps must be the size size (or else applying danger
	# map mask to interest map will not work)
	if interest_map.size() != danger_map.size():
		push_error("Interest and danger maps must be the same size. " + 
			"interest_map.size() = %d, danger_map.size() = %d" % 
			[interest_map.size(), danger_map.size()])
	
	# Find minimum in danger map, which is the allowed slot(s) for interest map
	var min = danger_map.min()
	
	# Set disallowed interest map slots to 0
	for i in range(danger_map.size()):
		if danger_map[i] != min: interest_map[i] = 0 # Disable index
	
	# Find remaining maximium interest map value and slot
	var max = interest_map.max()
	
	# TODO: calculate gradients of interest around chosen slot and estimate 
	# where they would meet, moving in that direction instead.
	
	# TODO: decrease resolution of course direction from distant targets.
	
	# Return direction of maximized interest map slot
	var max_index = interest_map.find(max)
	return directions[max_index]

func get_interest_map(objects: Array, collision_mask) -> Array:
	var map: Array
	
	var space_state = npc.get_world_2d().direct_space_state # Get space state
	
	for object in objects: # Loop through all targets
		var query = npc.PhysicsRayQueryParameters2D.create(npc.global_position, 
			object.global_position,
			collision_mask, [self]) # Cast Ray query from self to target
		var result = npc.space_state.intersect_ray(query) # Intersection data
		
		# Get distance scale factor. Further distance reduces intensity of dot
		# product result.
		var distance = npc.global_position.distance_to(object.global_position)
		var distance_factor = 1.0 / (distance + 1.0)
		# TODO: add a cut-off for distance?
		
		# Populate map
		# Dot product query Ray with each coordinate direction, then scale by
		# distance factor
		for i in range(directions.size()):
			var contribution = result.direction.dot(directions[i])
			map[i] += contribution * distance_factor
	
	return map

## Same as get_interest_map except the objects Array has coordinates, not Nodes
func get_danger_map(objects: Array, collision_mask) -> Array:
	var map: Array
	
	var space_state = npc.get_world_2d().direct_space_state # Get space state
	
	for object_coord in objects: # Loop through all targets
		var query = npc.PhysicsRayQueryParameters2D.create(npc.global_position, 
			object_coord,
			collision_mask, [self]) # Cast Ray query from self to target
		var result = npc.space_state.intersect_ray(query) # Intersection data
		
		# Get distance scale factor. Further distance reduces intensity of dot
		# product result.
		var distance = npc.global_position.distance_to(object_coord)
		var distance_factor = 1.0 / (distance + 1.0)
		# TODO: add a cut-off for distance?
		
		# Populate map
		# Dot product query Ray with each coordinate direction, then scale by
		# distance factor
		for i in range(directions.size()):
			var contribution = result.direction.dot(directions[i])
			map[i] += contribution * distance_factor
	
	return map
