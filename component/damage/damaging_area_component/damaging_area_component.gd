@tool
class_name DamagingAreaComponent
extends Area2D

@export var _damage: Damage
@export var _collision_filter: DamageableComponentCollisionFilter

@onready var _collisions_recolorer: CollisionsRecolorer = %CollisionsRecolorer

func _ready() -> void:
	_collisions_recolorer.collisions_color = _collision_filter.debug_color_damaging
	assert(_damage != null, "damage must be set")
	assert(_collision_filter != null, "coolision filter must be set")

func _on_area_entered(area: Area2D) -> void:
	if area is DamageableComponent:
		var damageable_area: DamageableComponent = area
		if (_collision_filter.is_compatible_with(damageable_area.collision_filter)):
			damageable_area.take_damage(_damage)
