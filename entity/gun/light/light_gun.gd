@tool
class_name LightGun
extends Node2D

#todo давать бонус при заспаме стрельбы + краснеть оружие, непонятно, должны ли проахи уменьшать урон следующего попадания при заспаме
#todo добавить еще разгон неточности от заспама

@export var damage: Damage
@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second should be positive")
		bps = value

@export var _max_distance: float:
	set(value):
		assert(value >= 0, "distance cant be less than 0")
		_max_distance = max(0, value)
@export var _base_spread_angle: float:
	set(value):
		assert(MathExtended.is_in_range(value, 0.0, 180), "the angle must be 0 < 180")
		_base_spread_angle = max(0, value)

@onready var _pivot: Node2D = %Pivot
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _damaging_ray_component: DamagingRayComponent = %DamagingRayComponent
@onready var _pointer_ray: RayCast2D = %PointerRay

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _time_since_last_shot: float = 0

var pointer_position: Vector2 = Vector2.ZERO:
	set(value):
		_pivot.look_at(value)
		if global_position.x > value.x:
			_sprite_2d.scale.y = -1
		else: 
			_sprite_2d.scale.y = 1
		_pointer_ray.global_position = value
		pointer_position = value
		
func _ready() -> void:
	_damaging_ray_component.damage = damage

func _process(delta: float) -> void:
	_time_since_last_shot += delta
	
func shoot() -> void:
	if not _can_shoot(): 
		return
	var pointer_damageable_component: DamageableComponent = _get_damageable_component_at_pointer()
	var distance_limit_by_pointer: float = _get_distance_limit_by(pointer_damageable_component)
	_damaging_ray_component.rotation_degrees = _rng.randf_range(-_base_spread_angle/2, _base_spread_angle/2)
	var distance: float = min(_max_distance, distance_limit_by_pointer)
	_damaging_ray_component.shoot(distance)
	_damage_if_not_damaged(pointer_damageable_component)
	_time_since_last_shot = 0

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
			damageable_component.take_damage(damage, "")
	
func _can_shoot() -> bool:
	return _time_since_last_shot > 1 / bps
