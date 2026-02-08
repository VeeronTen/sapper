@tool
class_name GunConfigurationFireModeConstant
extends GunConfigurationFireMode

@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second must be > 0")
		bps = value

@export_range(0, 180, 1, "degrees") var spread: float = 0.0
