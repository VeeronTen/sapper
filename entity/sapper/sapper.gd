class_name Sapper
extends CharacterBody2D

@export var walk_speed: float = 70.0
@export var walk_backwards_penalty: float = 0.80
@export var carrying_bomb_penalty: float = 0.80
@export var horizontal_flip_duration: float = 0.4
@export var time_to_walk_speed_modifier: Curve
@export var roll_speed_modifier: float = 3
@export var max_roll_time_secs: float = 0.4
@export_range(0, 1, 0.01, "suffix:%") var roll_contorlability: float = 0.5

@onready var _sprites: Node2D = $Sprites
@onready var _bomb_sprite: Sprite2D = %Bomb
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _damageable_component_ground: DamageableComponent = %DamageableComponentGround

var _is_carrying_bomb: bool = false:
	set(value):
		_is_carrying_bomb  = value
		_bomb_sprite.visible = _is_carrying_bomb
var _sprite_flip_tween: Tween = create_tween()
var _sprite_is_flipped_h_or_gonna: bool = false 

var watch_position: Vector2 = Vector2.RIGHT:
	set(value):
		_flip_sprit_horizontal(global_position.x > value.x)
		watch_position = value
		
var move_direction: Vector2 = Vector2.ZERO

var is_moving: bool = false:
	set(value):
		#hack анимации играть в аним ноде
		if value:
			_animation_player.play("walk")
		else: 
			_animation_player.play("idle")
		if not value:
			_walking_time = 0.0
		is_moving = value

var _walking_time: float = 0.0

var _is_rolling: bool = false:
	set(value):
		_damageable_component_ground.enable_childs(not value)
		_is_rolling = value
		
var _roll_direction: Vector2 = Vector2.ZERO

var _sprite_roll_tween: Tween = create_tween()

func _ready() -> void:
	_is_carrying_bomb = _is_carrying_bomb
	watch_position = watch_position
	move_direction = move_direction
	is_moving = is_moving
	_is_rolling = _is_rolling
	
func _physics_process(delta: float) -> void:
	var speed: float = _compute_speed()
	var direction: Vector2 = move_direction
	if _is_rolling:
		direction = (_roll_direction * (1 - roll_contorlability ) + move_direction * roll_contorlability) / 2
		direction = direction.normalized()
	elif is_moving: 
		_walking_time += delta
		#hack анимации играть в аним ноде
		_animation_player.speed_scale = speed / walk_speed
	velocity = speed * direction
	move_and_slide()

func try_to_roll() -> void:
	if _is_rolling or not is_moving:
		return
	_roll_direction = move_direction
	_is_rolling = true
	_sprite_roll_tween = create_tween()
	_sprite_roll_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	var animation_direction: int = 1
	if _sprite_is_flipped_h_or_gonna:
		animation_direction = -1
	_sprite_roll_tween.tween_property(_sprites, "rotation", 2 * PI * animation_direction, max_roll_time_secs).as_relative()	
	await get_tree().create_timer(max_roll_time_secs).timeout 
	_is_rolling = false
	
func _compute_speed() -> float:
	var result: float = walk_speed * time_to_walk_speed_modifier.sample(_walking_time)
	if _is_walking_backwards(): result *= walk_backwards_penalty
	if _is_carrying_bomb: result *= carrying_bomb_penalty
	if _is_rolling: result *= roll_speed_modifier
	return result
		
func _is_walking_backwards() -> bool:
	return (watch_position - global_position).dot(move_direction) < 0.0

#TODO @warning_ignore("return_value_discarded") в плагине не ворнить
func _flip_sprit_horizontal(flip_h: bool) -> void:
	if _sprite_is_flipped_h_or_gonna == flip_h: return
	_sprite_is_flipped_h_or_gonna = flip_h
	_sprite_flip_tween.kill()
	_sprite_flip_tween = create_tween()
	const full_flip_difference: float = 2
	var final_scale: float = 1
	if flip_h: final_scale = -1
	var needed_flip_difference: float = absf(final_scale - _sprites.scale.x)
	var duration: float = horizontal_flip_duration * (needed_flip_difference / full_flip_difference)
	_sprite_flip_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	_sprite_flip_tween.tween_property(_sprites, "scale:x", final_scale, duration)	
