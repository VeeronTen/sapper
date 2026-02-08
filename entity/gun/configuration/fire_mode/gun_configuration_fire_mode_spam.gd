@tool
class_name GunConfigurationFireModeSpam
extends GunConfigurationFireMode

@export var damage: Damage:
	set(value):
		assert(value, "damage must be set")
		damage = value
@export var damage_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, 1.0, "spam spread_time_coefficient")
		damage_time_coefficient = value

@export var enable_damage_time_coefficient_at_misses: bool:
	set(value):
		if not damage_time_coefficient:
			enable_damage_time_coefficient_at_misses = false
			return
		enable_damage_time_coefficient_at_misses = value
		
@export_range(0, 180, 1, "degrees") var spread: float = 0.0
@export var spread_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "spam spread_time_coefficient")
		spread_time_coefficient = value

@export var distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		distance = value
@export var distance_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "spam distance_time_coefficient")
		distance_time_coefficient = value

func _init() -> void:
	call_deferred("_validate")
	
func _validate() -> void:
	damage = damage
	damage_time_coefficient = damage_time_coefficient
	enable_damage_time_coefficient_at_misses = enable_damage_time_coefficient_at_misses
	spread = spread
	spread_time_coefficient = spread_time_coefficient
	distance = distance
	distance_time_coefficient = distance_time_coefficient
