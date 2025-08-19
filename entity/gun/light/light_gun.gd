class_name LightGun
extends Node2D

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
	_damaging_ray_component.shoot(distance)
