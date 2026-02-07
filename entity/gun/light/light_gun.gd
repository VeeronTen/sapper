@tool
class_name LightGun
extends Node2D

#todo оружие должно краснеть от заспама?
@export var damage: Damage:
	set(value):
		damage = value
		_allow_spam_with_multiplier = _allow_spam_with_multiplier
@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second should be positive")
		bps = value
		_allow_spam_with_multiplier = _allow_spam_with_multiplier
		_spam_spread_angle = _spam_spread_angle
@export var _allow_spam_with_multiplier: Curve:
	set(value):
		if value:
			value.max_domain = 1 / bps
			value.max_value = damage.value
		_allow_spam_with_multiplier = value
@export var _max_distance: float:
	set(value):
		assert(value >= 0, "distance cant be less than 0")
		_max_distance = max(0, value)
@export var _spam_spread_angle: Curve:
	set(value):
		if value:
			value.max_domain = 1 / bps
			value.max_value = 180
		_spam_spread_angle = value
		
@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _damaging_ray_component: DamagingRayComponent = %DamagingRayComponent
@onready var _pointer_ray: RayCast2D = %PointerRay
@onready var _gun_computer: GunComputer = %GunComputer

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _time_since_last_shot: float = 0
var _time_since_last_sucessfull_shot: float = 0

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		if global_position.x > value.x:
			_sprite_2d.scale.y = -1
		else: 
			_sprite_2d.scale.y = 1
		_pointer_ray.global_position = value
		pointer_position = value

func _process(delta: float) -> void:
	_time_since_last_shot += delta
	_time_since_last_sucessfull_shot += delta
	
func shoot() -> void:
	if not _can_shoot(): 
		return
	var pointer_damageable_component: DamageableComponent = _get_damageable_component_at_pointer()
	var distance_limit_by_pointer: float = _get_distance_limit_by(pointer_damageable_component)
	_damaging_ray_component.rotation_degrees = _get_spread()
	var distance: float = min(_max_distance, distance_limit_by_pointer)
	_damaging_ray_component.damage = _real_damage()
	_damaging_ray_component.shoot(distance)
	_damage_if_not_damaged(pointer_damageable_component)
	_time_since_last_shot = 0
	if not _damaging_ray_component.last_shot_damaged.is_empty():
		_time_since_last_sucessfull_shot = 0

func _get_damageable_component_at_pointer() -> DamageableComponent:
	_pointer_ray.force_raycast_update()
	while _pointer_ray.is_colliding():
		var collider: Object = _pointer_ray.get_collider()
		if collider is not DamageableComponent: return
		var damageable: DamageableComponent = collider
		_pointer_ray.clear_exceptions()
		return damageable
	return null

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
			damageable_component.take_damage(_real_damage(), "")
			_time_since_last_sucessfull_shot = 0
	
func _can_shoot() -> bool:
	if _allow_spam_with_multiplier: 
		return true
	return _time_since_last_shot > 1 / bps
	
func _real_damage() -> Damage:
	if _allow_spam_with_multiplier:
		var real_damage: Damage = damage.duplicate()
		real_damage.value = _allow_spam_with_multiplier.sample(_time_since_last_sucessfull_shot)	
		return real_damage
	else:
		return damage

func _get_spread() -> float:
	var samled_spread: float = _spam_spread_angle.sample(_time_since_last_shot)
	return _rng.randf_range(-samled_spread/2, samled_spread/2)
