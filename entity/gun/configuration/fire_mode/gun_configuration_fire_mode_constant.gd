@tool
class_name GunConfigurationFireModeConstant
extends GunConfigurationFireMode

@export var damage: Damage:
	set(value):
		assert(value, "damage must be set")
		damage = value
		
@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second must be > 0")
		bps = value

@export_range(0, 180, 1, "degrees") var spread: float = 0.0

@export var distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		distance = value
