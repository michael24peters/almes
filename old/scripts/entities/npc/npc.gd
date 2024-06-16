class_name NPC
extends CharacterBody2D

@export var idle_animation: AnimationPlayer
@export var hit_animation: AnimationPlayer
@export var death_animation: AnimationPlayer

var is_dead = false

@export var max_speed = 40.0 # fsm
@export var acceleration = 15.0 # fsm

@onready var ray_cast_2d = $RayCast2D # fsm
@onready var fsm = $FiniteStateMachine # fsm
@onready var npc_wander_state = $FiniteStateMachine/NPCWanderState # fsm
@onready var npc_chase_state = $FiniteStateMachine/NPCChaseState # fsm

func _ready():
	npc_wander_state.found_player.connect(fsm.change_state.bind(npc_chase_state)) # connect wander_state's found_player signal to change_state func to change to chase_state
	npc_chase_state.lost_player.connect(fsm.change_state.bind(npc_wander_state))

func _physics_process(delta):
	# TODO: change to follow position of player
	ray_cast_2d.target_position = get_local_mouse_position() # fsm

func _on_death():
	is_dead = true
	death_animation.play("die_left")
	idle_animation.stop() # replaced w/ setting physics process to false
	#set_physics_process(false)
	
func _on_damage_taken():
	if not is_dead:
		hit_animation.play("hit_left")
