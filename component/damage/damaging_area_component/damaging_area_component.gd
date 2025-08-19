class_name DamagingAreaComponent
extends Area2D

@export var _damage: Damage

func _on_area_entered(area: Area2D) -> void:
	if area is DamageableComponent:
		var damageable_area: DamageableComponent = area
		damageable_area.take_damage(_damage)
