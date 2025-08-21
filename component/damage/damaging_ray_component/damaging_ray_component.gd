@tool
class_name DamagingRayComponent
extends RayCast2D

@export var _initial_damage: Damage
@export var _is_piercing: bool = false
@export var _direction: Vector2 = Vector2.RIGHT:
	set(value):
		_direction = value.normalized()
		queue_redraw()
@export var _collision_filter: DamageableComponentCollisionFilter

@onready var _debug: DamagingRayComponentDebug = %DamagingRayComponentDebug

#todo ассерты показывают абстрактный класс без связи
func _ready() -> void:
	_direction = _direction
	assert(_initial_damage != null, "damage must be set")
	assert(_collision_filter != null, "coolision filter must be set")
#fixme все вот такие дровы косячат и будут отображены не так для других масштабов, что же делать
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, _direction * 10, Color.GOLD, 0.5)
	
# todo чтоб врезался в вещи (layer 1?), нужно два луча и смотреть, какой врезался раньше?
func shoot(distance: float) -> void:
	var collisions: Array[Vector2] = []
	target_position.x = distance
	var damage: Damage = _initial_damage
	force_raycast_update()
	while is_colliding():
		var damageable: DamageableComponent = get_collider()
		var is_compatible = _collision_filter.is_compatible_with(damageable.collision_filter)
		if not is_compatible:
			add_exception(damageable)
			force_raycast_update()
			continue
		collisions.append(get_collision_point())
		damageable.take_damage(damage)
		if not _is_piercing: break
		add_exception(damageable)
		force_raycast_update()
	clear_exceptions()
	if _debug.draw_hit_rays: 
		_debug.add_hit_ray(collisions, _is_piercing, to_global(target_position))
