extends Node2D

@export var attack_damage: float

@export var collision_box: Area2D

func _on_hitbox_area_entered(area):
	print("You hit!")
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		hitbox.damage(attack_damage)
		print("damage dealt")
