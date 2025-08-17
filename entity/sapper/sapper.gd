class_name Sapper
extends CharacterBody2D

@export var walk_speed: float = 2700.0
@export var walk_backwards_penalty: float = 0.80
@export var time_to_walk_speed_modifier: Curve

@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

var watch_position: Vector2 = Vector2.RIGHT:
	set(value):
		_sprite_2d.flip_h = global_position.x > value.x
		watch_position = value
		
var move_direction: Vector2 = Vector2.ZERO

var is_moving: bool = false:
	set(value):
		#hack анимации играть в аним ноде
		if value:
			_animation_player.play("walk_bomb")
		else: 
			_animation_player.play("idle_bomb")
		if not value: _walking_time = 0.0
		is_moving = value

var _walking_time: float = 0.0

func _ready() -> void:
	watch_position = watch_position
	move_direction = move_direction
	is_moving = is_moving
	
func _physics_process(delta: float) -> void:
	if is_moving: _walking_time += delta
	var move_speed = walk_speed * time_to_walk_speed_modifier.sample(_walking_time)
	if _is_walking_backwards():
		move_speed *= walk_backwards_penalty
	#hack анимации играть в аним ноде
	_animation_player.speed_scale = move_speed / walk_speed
	velocity = move_speed * move_direction * delta
	move_and_slide()

func _is_walking_backwards() -> bool:
	return (watch_position - global_position).dot(move_direction) < 0.0
