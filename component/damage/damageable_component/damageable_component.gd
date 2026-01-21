@tool
class_name DamageableComponent
extends Area2D

signal took_damage

@export var collision_filter: DamageableComponentCollisionFilter
@export var _damage_filter: DamageFilter
@export var _health: HealthComponent

@onready var _collisions_recolorer: CollisionsRecolorer = %CollisionsRecolorer
	
var _block_stacking_tags: Array[String] = []
#todo как запретить создание ноды и оставить только сцену?
#todo должен бвть еще damage filter для друзей/врагов, то есть будет несколько измерений, а сейм должен быть стратегией разрешения а не прямым наследником
func _ready() -> void:
	_collisions_recolorer.collisions_color = collision_filter.debug_color_damageable
	assert(_health != null, "health must be set")
	assert(collision_filter != null, "coolision filter must be set")

func _physics_process(_delta: float) -> void:
	_block_stacking_tags.clear()
	
func take_damage(damage: Damage, block_stacking_tag: String) -> void:
	if _process_block_stacking(block_stacking_tag): 
		return
	var resulting_damage: Damage = damage
	if _damage_filter != null:
		resulting_damage = _damage_filter.filter_damage(resulting_damage)
	took_damage.emit()
	_health.take_damage(resulting_damage)
	
func enable_childs(enable: bool) -> void:
	for child: Node in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", not enable)

func _process_block_stacking(block_stacking_tag: String) -> bool:
	if block_stacking_tag.is_empty(): return false
	if _block_stacking_tags.has(block_stacking_tag): return true
	_block_stacking_tags.append(block_stacking_tag)
	return false
