@tool
class_name LightGun
extends Node2D

@export var _max_distance: float:
	set(value):
		assert(value >= 0, "distance cant be less than 0")
		_max_distance = max(0, value)
@export var _distance_to_shoot_above_ground: float:
	set(value):
		assert(MathExtended.is_in_range(value, 0.0, _max_distance), "the distance is restricted by max_distance and cant be < 0")
		_distance_to_shoot_above_ground = clamp(value, 0, _max_distance)

@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _damaging_ray_component: DamagingRayComponent = %DamagingRayComponent

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		if global_position.x > value.x:
			_sprite_2d.scale.y = -1
		else: 
			_sprite_2d.scale.y = 1
		pointer_position = value

func shoot() -> void:
	var distance: float = pointer_position.distance_to(_damaging_ray_component.global_position)
	if distance > _distance_to_shoot_above_ground:
		distance = _max_distance
	_damaging_ray_component.shoot(distance)
