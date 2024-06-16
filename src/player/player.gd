extends Character
class_name Player

'''
Here, a child state will communicate behavior to the Player, which is normally
bad practice. In this case, the Player merely acts as a hub for state brains to 
dictate behavior, which is managed by the FiniteStateMachine.
'''

@onready var fsm = $FSM as FiniteStateMachine
@onready var animations = $AnimatedSprite2D as AnimatedSprite2D
@onready var move_component = $MoveComponent
@onready var attack_component = $AttackComponent


func _ready() -> void:
	fsm.init(self, animations, 
		move_component, attack_component) # State needs a CB2D, but no specific one!
	
func _unhandled_input(event: InputEvent) -> void:
	fsm.process_input(event)
	
func _physics_process(delta: float) -> void:
	fsm.process_physics(delta)
	
func _process(delta: float) -> void:
	# NOTE: this may potentially belong in physics_process. 
	# Change if it causes problems in the future
	fsm.process_frame(delta)

