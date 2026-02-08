@tool
class_name GunConfiguration
extends Resource


@export var fire_mode: GunConfigurationFireMode







@export var damage: Damage:
	set(value):
		assert(value, "damage must be set")
		damage = value
		damage.changed.connect(func() -> void: damage_spam_override = damage_spam_override)
		damage_spam_override = damage_spam_override

@export var damage_spam_override: Curve:
	set(value):
		if value:
			var x_bounds: Vector2 = Vector2(0.0, 1 / bps)
			var y_bounds: Vector2 = Vector2(0.0, damage.value)
			#CurveExtended.set_strict_bounds(value, x_bounds, y_bounds, "damage spam")
		damage_spam_override = value

@export var max_distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		max_distance = max(0, value)
