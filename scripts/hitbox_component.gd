extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent
@export var accept_collisions = true

@onready var collision = $CollisionShape2D

signal damage_taken

func _physics_process(delta):
	can_accept_collision()

func damage(damage):
	if health_component && accept_collisions:
		health_component.damage(damage)
		damage_taken.emit()
		# TODO: check died signal; if true, disable collisions

func can_accept_collision():
	if health_component.hit_points > 0: collision.disabled = false
	else: collision.disabled = true
