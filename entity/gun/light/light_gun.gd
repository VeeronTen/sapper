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

#todo добавить еще разгон неточности от заспама
@export var _base_spread_angle: float:
	set(value):
		assert(MathExtended.is_in_range(value, 0.0, 180), "the angle must be 0 < 180")
		_base_spread_angle = max(0, value)
		
@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _damaging_ray_component: DamagingRayComponent = %DamagingRayComponent
#@onready var _damaging_ray_component_init_rotation: float = _damaging_ray_component.rotation_degrees

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		if global_position.x > value.x:
			_sprite_2d.scale.y = -1
		else: 
			_sprite_2d.scale.y = 1
		pointer_position = value
# todo получается фильтр должен и по лежащим сработать целям

# todo Вот тут хотел жестко логику менять с стрельбой по высоте и т д
func shoot() -> void:
	_damaging_ray_component.rotation_degrees = _rng.randf_range(-_base_spread_angle/2, _base_spread_angle/2)
	var horizontal_diviation = abs(_damaging_ray_component.rotation_degrees)/(_base_spread_angle/2)
	var distance: float = pointer_position.distance_to(_damaging_ray_component.global_position)
	var max_vertical_deviation = distance * sqrt(2 - 2 * cos(deg_to_rad(_base_spread_angle)))
	var max_vertical_deviation_after_horizontal = max_vertical_deviation * (1 - horizontal_diviation)
	distance = distance + _rng.randf_range(-max_vertical_deviation_after_horizontal / 2, max_vertical_deviation_after_horizontal / 2)
	var over_ground_of_max_distance = (distance - _distance_to_shoot_above_ground) / (_max_distance - _distance_to_shoot_above_ground)
	distance = clamp(distance * (1 + over_ground_of_max_distance), distance, _max_distance)
	_damaging_ray_component.shoot(distance)
