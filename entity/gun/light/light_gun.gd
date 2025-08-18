class_name LightGun
extends Node2D

@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _shooting_ray: RayCast2D = %ShootingRay

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		if global_position.x > value.x:
			_sprite_2d.scale.y = -1
		else: 
			_sprite_2d.scale.y = 1
		pointer_position = value
		
#todo не так втупую дамажить, а тоже через компонент
func shoot() -> void:
	_shooting_ray.target_position = Vector2.ZERO
	_shooting_ray.target_position.x = pointer_position.distance_to(_shooting_ray.global_position)
	_shooting_ray.	force_raycast_update()
	if _shooting_ray.is_colliding():
		var node = _shooting_ray.get_collider() as DamageableComponent
		var dmg = Damage.new()
		dmg.value = 3
		node.take_damage(dmg)
