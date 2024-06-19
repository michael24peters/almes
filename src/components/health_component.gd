extends Node2D
class_name HealthComponent

@export var MAX_HIT_POINTS := 1.0
var hit_points : float

signal health_changed
signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_points = MAX_HIT_POINTS

func damage(damage):
	print("damage = ", damage)
	hit_points -= damage
	hit_points = clamp(hit_points, 0, MAX_HIT_POINTS) # Cannot go past 0 or max hp bounds
	health_changed.emit() # Emit signal
	if hit_points == 0: 
		print("Slain!") # TODO: death mechanics
		died.emit() # Death

func heal(healing):
	damage(-healing) # negative (-) damage = healing
