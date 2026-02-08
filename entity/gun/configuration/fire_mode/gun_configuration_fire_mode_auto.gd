@tool
class_name GunConfigurationFireModeAuto
extends GunConfigurationFireMode

@export var damage: Damage:
	set(value):
		assert(value, "damage must be set")
		damage = value
@export var damage_hold_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto damage_hold_time_coefficient")
		damage_hold_time_coefficient = value

@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second must be > 0")
		bps = value
@export var bps_hold_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto bps_hold_time_coefficient")
		bps_hold_time_coefficient = value


@export_range(0, 180, 1, "degrees") var spread: float = 0.0
@export var spread_hold_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto spread_hold_time_coefficient")
		spread_hold_time_coefficient = value

@export var distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		distance = value
@export var distance_hold_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "auto distance_hold_time_coefficient")
		distance_hold_time_coefficient = value

func _init() -> void:
	call_deferred("_validate")
	
func _validate() -> void:
	damage = damage
	damage_hold_time_coefficient = damage_hold_time_coefficient
	bps = bps
	bps_hold_time_coefficient = bps_hold_time_coefficient
	spread = spread
	spread_hold_time_coefficient = spread_hold_time_coefficient
	distance = distance
	distance_hold_time_coefficient = distance_hold_time_coefficient
