extends CharacterBody2D

@export var walk_speed: float = 70.0
@export var chase_speed: float = 100.0
@export var attack_speed: float = 240.0
@export var attack_accuracy: float = 0.8

@onready var state_chart: StateChart = %StateChart
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_area: Area2D = %AttackArea
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

#todo крутую навигацию добавить

var _target: Node2D = null
var _attack_direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	sprite_2d.flip_h = velocity.x > 0

func _on_start_walk_taken() -> void:
	var map_rid: RID = navigation_agent_2d.get_navigation_map()
	var random_point: Vector2 = NavigationServer2D.map_get_random_point(
		map_rid, 
		navigation_agent_2d.navigation_layers, 
		true
	)
	navigation_agent_2d.target_position = random_point

func _on_walk_state_processing(_delta: float) -> void:
	velocity = _get_path_direction() * walk_speed
	move_and_slide()

func _on_chasing_state_physics_processing(_delta: float) -> void:
	velocity = _get_path_direction() * chase_speed
	move_and_slide()
	
func _on_attacking_state_physics_processing(_delta: float) -> void:
	velocity = _attack_direction * attack_speed
	move_and_slide()
	
func _on_watch_area_body_entered(body: Node2D) -> void:
	#todo отвязаться от имени
	if body.name == "Sapper":
		_target = body
		state_chart.send_event("found_target")

func _on_preparing_to_attack_state_entered() -> void:
	_attack_direction = _get_vector_to_target().normalized()
	animation_player.play("prepare_attack")

func _on_attacking_state_entered() -> void:
	var actual_attack_direction: Vector2 = _get_vector_to_target().normalized()
	var not_normilized_weighted_direction: Vector2 = lerp(_attack_direction, actual_attack_direction, attack_accuracy)
	_attack_direction = not_normilized_weighted_direction.normalized()
	animation_player.play("attack")

func _on_idle_state_entered() -> void:
	animation_player.play("idle")

func _on_walk_state_entered() -> void:
	animation_player.play("run")

func _on_chasing_state_entered() -> void:
	animation_player.play("run")
	navigation_agent_2d.target_position = _target.global_position
	if attack_area.get_overlapping_bodies().any(func(elemnt: Node2D) -> bool: return elemnt == _target):
		state_chart.send_event("ready_to_attack")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == _target:
		state_chart.send_event("ready_to_attack")

func _on_recalculate_path_taken() -> void:
	_recalculate_path()
	
func _on_navigation_agent_2d_navigation_finished() -> void:
	_recalculate_path()
	
func _get_vector_to_target() -> Vector2:
	return _target.global_position - global_position

func _get_path_direction() -> Vector2:
	if navigation_agent_2d.is_navigation_finished():
		return Vector2.ZERO
	else:
		return to_local(navigation_agent_2d.get_next_path_position()).normalized()

func _recalculate_path() -> void:
	navigation_agent_2d.target_position = _target.global_position
