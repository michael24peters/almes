extends CharacterBody2D

@export var idle_animation: AnimationPlayer
@export var hit_animation: AnimationPlayer
@export var death_animation: AnimationPlayer

var is_dead = false

func _physics_process(delta):
	pass

func _on_death():
	is_dead = true
	death_animation.play("die_left")
	idle_animation.stop()
	
func _on_damage_taken():
	if not is_dead:
		hit_animation.play("hit_left")
