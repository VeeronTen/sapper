class_name Sapper
extends CharacterBody2D

@export var walk_speed: float = 2700.0
@export var time_to_walk_speed_modifier: Curve

@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

var direction: Vector2 = Vector2.ZERO:
	set(value):
		if (value.x != 0): _sprite_2d.flip_h = value.x < 0.0
		direction = value

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
	direction = direction
	is_moving = is_moving
	
func _physics_process(delta: float) -> void:
	if is_moving: _walking_time += delta
	#hack анимации играть в аним ноде
	_animation_player.speed_scale = time_to_walk_speed_modifier.sample(_walking_time)
	velocity = direction * walk_speed * time_to_walk_speed_modifier.sample(_walking_time) * delta
	move_and_slide()
