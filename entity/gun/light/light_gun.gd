@tool
class_name LightGun
extends Node2D

#todo оружие должно краснеть от заспама?

@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _damaging_ray_component: DamagingRayComponent = %DamagingRayComponent
@onready var _gun_computer: GunComputer = %GunComputer
@onready var _gun_pointer: GunPointer = %GunPointer
@onready var _trace: Line2D = %Trace

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		if global_position.x > value.x:
			_sprite_2d.scale.y = -1
		else: 
			_sprite_2d.scale.y = 1
		_gun_pointer.global_position = value
		pointer_position = value

func shoot(hold: bool) -> void:
	if not _gun_computer.can_shoot(hold): 
		return
	var pointer_damageable_component: DamageableComponent = _gun_pointer.get_damageable_component_at_pointer()
	var distance_limit_by_pointer: float = _get_distance_limit_by(pointer_damageable_component)
	_damaging_ray_component.rotation_degrees = _gun_computer.get_spread()
	var distance: float = min(_gun_computer.get_distance(), distance_limit_by_pointer)
	_damaging_ray_component.damage = _gun_computer.get_damage()
	_damaging_ray_component.shoot(distance)
	#todo по лежачим целям пролетает странно
	shootXXX(_damaging_ray_component.last_shot_distance)
	_damage_if_not_damaged(pointer_damageable_component)
	_gun_computer.on_shot()
	if not _damaging_ray_component.last_shot_damaged.is_empty():
		_gun_computer.on_succesfull_shot()

func _get_distance_limit_by(damageableComponent: DamageableComponent) -> float:
	if damageableComponent:
		return global_position.distance_to(damageableComponent.global_position)
	else:
		return 9999999999

func _damage_if_not_damaged(damageable_component: DamageableComponent) -> void:
	if _damaging_ray_component.last_shot_exceptions.has(damageable_component):
		var damaged_parents: Array = _damaging_ray_component.last_shot_damaged.map(
			func(node: DamageableComponent) -> Node: return node.get_parent()
		)
		if not damaged_parents.has(damageable_component.get_parent()):
			damageable_component.take_damage(_gun_computer.get_damage(), "")
			_gun_computer.on_succesfull_shot()

func shootXXX(distance: float):
	_trace.set_point_position(0, Vector2.ZERO)
	if distance:
		_trace.set_point_position(1, Vector2(distance, 0))
		#spawn_impact_particles(cast_point) # Искры здесь
	else:
		_trace.set_point_position(1, Vector2.ZERO)
	animate_shot()

#env glow + shaders + particle color
func animate_shot():
	_trace.show()
	var tween = create_tween()
	tween.tween_property(_trace, "width", 0, 0.1)
	tween.tween_callback(_trace.hide)
	tween.finished.connect(func(): _trace.width = 1)
