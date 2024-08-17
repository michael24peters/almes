extends Area2D
class_name HurtboxComponent

@onready var collision = $CollisionShape2D
@onready var health_component = $"../HealthComponent"

func _ready():
	connect("area_entered", Callable(self, "on_area_entered"))

func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox == null: # Not a HitboxComponent
		return

	health_component.damage(hitbox.damage)
