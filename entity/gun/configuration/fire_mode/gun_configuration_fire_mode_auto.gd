@tool
class_name GunConfigurationFireModeAuto
extends GunConfigurationFireMode

@export var damage: Damage:
	set(value):
		assert(value, "damage must be set")
		damage = value
@export var damage_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto damage_time_coefficient")
		damage_time_coefficient = value

@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second must be > 0")
		bps = value
@export var bps_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto bps_time_coefficient")
		bps_time_coefficient = value


@export_range(0, 180, 1, "degrees") var spread: float = 0.0
@export var spread_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto spread_time_coefficient")
		spread_time_coefficient = value

@export var distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		distance = value
@export var distance_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto distance_time_coefficient")
		distance_time_coefficient = value
