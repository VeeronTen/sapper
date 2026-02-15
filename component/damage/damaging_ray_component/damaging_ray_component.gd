@tool
class_name DamagingRayComponent
extends RayCast2D

@export var damage: Damage
@export var _is_piercing: bool = false
@export var _direction: Vector2 = Vector2.RIGHT:
	set(value):
		_direction = value.normalized()
		queue_redraw()
@export var _collision_filter: DamageableComponentCollisionFilter
@export var block_stacking_tag: String

@onready var _debug: DamagingRayComponentDebug = %DamagingRayComponentDebug

var last_shot_exceptions: Array[DamageableComponent] = []
var last_shot_damaged: Array[DamageableComponent] = []
var last_shot_distance: float = 0

#todo ассерты показывают абстрактный класс без связи
func _ready() -> void:
	_direction = _direction
	assert(_collision_filter != null, "coolision filter must be set")
#fixme все вот такие дровы косячат и будут отображены не так для других масштабов, что же делать
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, _direction * 10, Color.GOLD, 0.5)
	
func shoot(distance: float) -> void:
	var collisions: Array[Vector2] = []
	target_position.x = distance
	_clear_exceptions()
	last_shot_damaged.clear()
	last_shot_distance = distance
	force_raycast_update()
	while is_colliding():
		var collider: Object = get_collider()
		if collider is not DamageableComponent:
			collisions.append(get_collision_point())
			last_shot_distance = to_local(get_collision_point()).x
			break
		var damageable: DamageableComponent = collider
		var is_compatible: bool = _collision_filter.is_compatible_with(damageable.collision_filter)
		if not is_compatible:
			_add_exception(damageable)
			force_raycast_update()
			continue
		collisions.append(get_collision_point())
		damageable.take_damage(damage, block_stacking_tag)
		last_shot_damaged.append(damageable)
		last_shot_distance = to_local(get_collision_point()).x
		if not _is_piercing: break
		_add_exception(damageable)
		force_raycast_update()
	if _debug.draw_hit_rays: 
		_debug.add_hit_ray(collisions, _is_piercing, to_global(target_position))

func _add_exception(damageable_component: DamageableComponent) -> void:
	add_exception(damageable_component)
	last_shot_exceptions.append(damageable_component)
	
func _clear_exceptions() -> void:
	clear_exceptions()
	last_shot_exceptions.clear()
