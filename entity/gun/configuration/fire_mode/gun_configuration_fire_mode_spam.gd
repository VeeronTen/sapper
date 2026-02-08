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
