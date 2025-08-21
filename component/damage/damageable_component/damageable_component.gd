class_name DamageableComponent
extends Area2D

@export var _damage_filter: DamageFilter
@export var _health: HealthComponent
#todo как запретить создание ноды и оставить только сцену?

func take_damage(damage: Damage) -> void:
	var resulting_damage: Damage = damage
	if _damage_filter != null:
		resulting_damage = _damage_filter.filter_damage(resulting_damage)
	_health.take_damage(resulting_damage)
