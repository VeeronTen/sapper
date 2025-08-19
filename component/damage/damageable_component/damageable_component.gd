@tool
class_name DamageableComponent
extends Area2D

@export var _damage_filter: DamageFilter
@export var _health: HealthComponent
#todo как запретить создание ноды и оставить только сцену?

func _ready() -> void:
	if Engine.is_editor_hint: _recolor_debug_areas()

func take_damage(damage: Damage) -> void:
	var resulting_damage: Damage = damage
	if _damage_filter != null:
		resulting_damage = _damage_filter.filter_damage(resulting_damage)
	_health.take_damage(resulting_damage)

func _recolor_debug_areas() -> void:
	for child: Node in get_children():
		if child is CollisionShape2D:
			var collision: CollisionShape2D = child
			collision.debug_color = Color.hex(0x519d536b)
