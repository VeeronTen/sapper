@tool
class_name GunConfigurationFireModeSpam
extends GunConfigurationFireMode

@export_range(0, 180, 1, "degrees") var spread: float = 0.0
@export var spread_time_coefficient: Curve:
	set(value):
		if value:
			CurveExtended.set_strict_bounds(value, 0.0, null, 0.0, null, "spam spread_time_coefficient")
		spread_time_coefficient = value
