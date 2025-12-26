extends CharacterBody2D

@export var walk_speed: float = 2100.0
@export var chase_speed: float = 3100.0
@export var attack_speed: float = 8100.0
@export var distance_to_attack: float = 45
@export var attack_accuracy: float = 0.66

@onready var state_chart: StateChart = %StateChart
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

#todo все таймеры сделать с програмными значениями, а не едитора
#todo крутую навигацию добавить

var _walk_directopn: Vector2 = Vector2.ZERO
var _target: Node2D = null
var _attack_direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	sprite_2d.flip_h = velocity.x > 0

func _on_start_walk_taken() -> void:
	_walk_directopn = Vector2( randf_range(-1, 1),  randf_range(-1, 1)).normalized()

func _on_walk_state_processing(delta: float) -> void:
	velocity = _walk_directopn * delta * walk_speed
	move_and_slide()

func _on_chasing_state_physics_processing(delta: float) -> void:
	var to_target: Vector2 = _target.global_position - global_position
	if (to_target.length() < distance_to_attack):
		state_chart.send_event("ready_to_attack")
	var direction: Vector2 = to_target.normalized()
	velocity = direction * delta * chase_speed
	move_and_slide()
	
func _on_attacking_state_physics_processing(delta: float) -> void:
	velocity = _attack_direction * delta * attack_speed
	move_and_slide()
	
func _on_watch_area_body_entered(body: Node2D) -> void:
	#todo отвязаться от имени
	if body.name == "Sapper":
		_target = body
		state_chart.send_event("found_target")

func _on_preparing_to_attack_state_entered() -> void:
	_attack_direction = (_target.global_position - global_position).normalized()
	animation_player.play("prepare_attack")

func _on_attacking_state_entered() -> void:
	var actual_attack_direction: Vector2 = (_target.global_position - global_position).normalized()
	_attack_direction = lerp(_attack_direction, actual_attack_direction, attack_accuracy).normalized()
	animation_player.play("attack")

func _on_idle_state_entered() -> void:
	animation_player.play("idle")

func _on_walk_state_entered() -> void:
	animation_player.play("run")

func _on_chasing_state_entered() -> void:
	animation_player.play("run")
