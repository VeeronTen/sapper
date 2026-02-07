@tool
class_name GunConfiguration
extends Resource

@export var _damage: Damage:
	set(value):
		assert(value, "damage must be set")
		_damage = value
		_damage.changed.connect(func() -> void: _damage_spam_override = _damage_spam_override)
		_damage_spam_override = _damage_spam_override

@export var _bps: float:
	set(value):
		assert(value > 0, "bullets per second must be > 0")
		_bps = value
		_damage_spam_override = _damage_spam_override
		_spread_spam_override = _spread_spam_override

#@export var _spread: float: todo сделать статич7ный спред, спам спред, время спред все отдельные поляя
#todo то есть поля не оверрайд, а тип констант, спам, зажим и т д но не все можно пикнуть, а только подходящее
	#set(value):
		#assert(value >= 0, "spread cant be < 0")
		#_spread = value
		#_spread_spam_override = _spread_spam_override

@export var _damage_spam_override: Curve:
	set(value):
		if value:
			var x_bounds: Vector2 = Vector2(0.0, 1 / _bps)
			var y_bounds: Vector2 = Vector2(0.0, _damage.value)
			CurveExtended.set_strict_bounds(value, x_bounds, y_bounds, "damage spam")
		_damage_spam_override = value

@export var _max_distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		_max_distance = max(0, value)

@export var _spread_spam_override: Curve:
	set(value):
		if value:
			var x_bounds: Vector2 = Vector2(0.0, 1 / _bps)
			var y_bounds: Vector2 = Vector2(0.0, 180.0)
			CurveExtended.set_strict_bounds(value, x_bounds, y_bounds, "spread spam")
		_spread_spam_override = value
