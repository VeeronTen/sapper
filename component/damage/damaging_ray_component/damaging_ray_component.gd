@tool
class_name DamagingRayComponent
extends RayCast2D

@export var _initial_damage: Damage

@export var _is_piercing: bool = false
		
@export var _direction: Vector2 = Vector2.RIGHT:
	set(value):
		_direction = value.normalized()
		queue_redraw()

func _ready() -> void:
	_direction = _direction
	if not Engine.is_editor_hint():
		assert(_initial_damage != null, "damage must be set")
		
#fixme все вот такие дровы косячат и будут отображены не так для других масштабов, что же делать
func _draw() -> void:
	if not Engine.is_editor_hint(): return
	draw_line(Vector2.ZERO, _direction * 10, Color.GOLD, 0.5)
	
# todo чтоб врезался в вещи (layer 1?), нужно два луча и смотреть, какой врезался раньше?
func shoot(distance: float) -> void:
	target_position.x = distance
	var damage: Damage = _initial_damage
	force_raycast_update()
	while is_colliding():
		var damageable: DamageableComponent = get_collider()
		damageable.take_damage(damage)
		if not _is_piercing: break
		add_exception(damageable)
		force_raycast_update()
	clear_exceptions()
