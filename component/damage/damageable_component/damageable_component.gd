@tool
class_name DamageableComponent
extends Area2D

@export var _damage_filter: DamageFilter
@export var _health: HealthComponent
#todo как запретить создание ноды и оставить только сцену?

func _ready() -> void:
	if Engine.is_editor_hint: _recolor_debug_areas()

func _on_area_entered(area: Area2D) -> void:
	if area is DamagingComponent:
		take_damage(area.get_damage())
#todo damaging должен искать а не наоборот

func take_damage(damage: Damage) -> void:
	var resulting_damage = damage
	if _damage_filter != null:
		resulting_damage = _damage_filter.filter_damage(resulting_damage)
	_health.take_damage(resulting_damage)

func _recolor_debug_areas() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = Color.hex(0x519d536b)
