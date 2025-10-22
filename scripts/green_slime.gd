extends CharacterBody2D

const SPEED = 50
@export var player: Node2D
@export var nemico1: Node2D
@export var ambush_distance: float = 64
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

# Salvo l'ultima posizione del player per capire se si muove
var last_player_pos: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Calcola direzione verso il prossimo punto del percorso
	var dir = (nav_agent.get_next_path_position() - global_position).normalized()
	velocity = dir * SPEED
	move_and_slide()

func calculate_ambush_point() -> Vector2:
	# Direzione del player
	var player_dir = player.get("dir") if player.has_method("get") else Vector2.ZERO
	
	# Punto davanti al player
	var point_ahead = player.global_position + player_dir * ambush_distance
	
	# Punto intermedio tra nemico1 e punto davanti al player
	var ambush_point = (point_ahead + nemico1.global_position) / 2
	
	# Controllo se ci sono biforcazioni 
	if (global_position.distance_to(nemico1.global_position) < 50):
		var perp = Vector2(-(nemico1.global_position.y - global_position.y),
						   nemico1.global_position.x - global_position.x).normalized()
		ambush_point += perp * 32  
	
	return ambush_point

func makepath() -> void:
	# Se il player è fermo, aspetta che nemico1 si muova
	if player.global_position == last_player_pos and global_position.distance_to(nemico1.global_position) < 5:
		return
	
	nav_agent.target_position = calculate_ambush_point()
	last_player_pos = player.global_position

func _on_timer_timeout() -> void:
	makepath()
