class_name LightGun
extends Node2D

@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		_sprite_2d.flip_v = global_position.x > value.x
		pointer_position = value
