extends CharacterBody2D

const SPEED = 50

enum State { CHASE, SCATTER }
var state: State = State.CHASE

@export var player: Node2D
@export var nemico1: Node2D
@export var scatter_target: Vector2 = Vector2.ZERO
@export var ambush_distance: float = 64

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _physics_process(delta: float) -> void:
	var dir = (nav_agent.get_next_path_position() - global_position).normalized()
	velocity = dir * SPEED
	move_and_slide()

func _on_timer_timeout() -> void:
	match state:
		State.CHASE:
			makepath_chase()
		State.SCATTER:
			makepath_scatter()

func makepath_chase() -> void:
	# Override nei singoli nemici
	pass

func makepath_scatter() -> void:
	nav_agent.target_position = scatter_target
