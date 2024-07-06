extends Area2D
class_name HitboxComponent

@onready var collision = $CollisionShape2D

signal damage_taken(amount: float)
signal hp_received(amount: float)

func damage(amount: float):
	if !collision.disabled:
		damage_taken.emit(amount)
		# TODO: check died signal; if true, disable collisions

func heal(amount: float):
	if !collision.disabled:
		hp_received.emit(amount)

func _on_died():
	collision.disabled = true
