@tool
class_name GunConfiguration
extends Resource

@export var damage: Damage:
	set(value):
		assert(value, "damage must be set")
		damage = value
		damage.changed.connect(func() -> void: damage_spam_override = damage_spam_override)
		damage_spam_override = damage_spam_override

@export var bps: float:
	set(value):
		assert(value > 0, "bullets per second must be > 0")
		bps = value
		damage_spam_override = damage_spam_override
		spread_spam_override = spread_spam_override

#@export var spread: float: todo сделать статич7ный спред, спам спред, время спред все отдельные поляя
#todo то есть поля не оверрайд, а тип констант, спам, зажим и т д но не все можно пикнуть, а только подходящее
	#set(value):
		#assert(value >= 0, "spread cant be < 0")
		#_spread = value
		#_spread_spam_override = _spread_spam_override

@export var damage_spam_override: Curve:
	set(value):
		if value:
			var x_bounds: Vector2 = Vector2(0.0, 1 / bps)
			var y_bounds: Vector2 = Vector2(0.0, damage.value)
			CurveExtended.set_strict_bounds(value, x_bounds, y_bounds, "damage spam")
		damage_spam_override = value

@export var max_distance: float:
	set(value):
		assert(value >= 0, "distance cant be < 0")
		max_distance = max(0, value)
#todo вместо сырых значений нужны коэфициенты, чтобы можно было перемножать
@export var spread_spam_override: Curve:
	set(value):
		if value:
			var x_bounds: Vector2 = Vector2(0.0, 1 / bps)
			var y_bounds: Vector2 = Vector2(0.0, 180.0)
			CurveExtended.set_strict_bounds(value, x_bounds, y_bounds, "spread spam")
		spread_spam_override = value
