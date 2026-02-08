class_name GunComputer
extends Node

@export var _configuration: GunConfiguration

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _time_since_last_shot: float = 0
var _time_since_last_sucessfull_shot: float = 0

var _time_hold: float = 0
var is_holding: bool = false
	
func _process(delta: float) -> void:
	_time_since_last_shot += delta
	_time_since_last_sucessfull_shot += delta
	if is_holding:
		_time_hold += delta
	else:
		_time_hold = 0.0
	
func can_shoot(hold: bool) -> bool:
	is_holding = hold
	match _configuration.fire_mode:
		var mode when mode is GunConfigurationFireModeConstant:
			if hold: return false
			var constant: GunConfigurationFireModeConstant = mode
			return _time_since_last_shot > 1 / constant.bps
		var mode when mode is GunConfigurationFireModeAuto:
			var auto: GunConfigurationFireModeAuto = mode
			var bps: float = auto.bps
			if auto.bps_time_coefficient:
				bps *= auto.bps_time_coefficient.sample(_time_hold)
			return _time_since_last_shot > 1 / bps
		var mode when mode is GunConfigurationFireModeSpam:
			if hold: return false
			var spam: GunConfigurationFireModeSpam = mode
			return true
		_:
			assert(false)
			return false

func get_damage() -> Damage:
	var damage: Damage
	match _configuration.fire_mode:
		var mode when mode is GunConfigurationFireModeConstant:
			var constant: GunConfigurationFireModeConstant = mode
			damage = constant.damage
		var mode when mode is GunConfigurationFireModeAuto:
			var auto: GunConfigurationFireModeAuto = mode
			damage = auto.damage.duplicate()
			if auto.damage_time_coefficient:
				damage.value *= auto.damage_time_coefficient.sample(_time_hold)
		var mode when mode is GunConfigurationFireModeSpam:
			var spam: GunConfigurationFireModeSpam = mode
			damage = spam.damage.duplicate()
			if spam.damage_time_coefficient:
				var time: float = _time_since_last_shot if spam.enable_damage_time_coefficient_at_misses else _time_since_last_sucessfull_shot
				damage.value *= spam.damage_time_coefficient.sample(time)
		_:
			assert(false)
			return null
	return damage

func get_spread() -> float:
	var spread: float
	match _configuration.fire_mode:
		var mode when mode is GunConfigurationFireModeConstant:
			var constant: GunConfigurationFireModeConstant = mode
			spread = constant.spread
		var mode when mode is GunConfigurationFireModeAuto:
			var auto: GunConfigurationFireModeAuto = mode
			spread = auto.spread
			if auto.spread_time_coefficient:
				spread *= auto.spread_time_coefficient.sample(_time_hold)
		var mode when mode is GunConfigurationFireModeSpam:
			var spam: GunConfigurationFireModeSpam = mode
			spread = spam.spread
			if spam.spread_time_coefficient:
				spread *= spam.spread_time_coefficient.sample(_time_since_last_shot)
		_:
			assert(false)
			return 0
	return _rng.randf_range(-spread/2, spread/2)

func get_distance() -> float:
	var distance: float
	match _configuration.fire_mode:
		var mode when mode is GunConfigurationFireModeConstant:
			var constant: GunConfigurationFireModeConstant = mode
			distance = constant.distance
		var mode when mode is GunConfigurationFireModeAuto:
			var auto: GunConfigurationFireModeAuto = mode
			distance = auto.distance
			if auto.distance_time_coefficient:
				distance *= auto.distance_time_coefficient.sample(_time_hold)
		var mode when mode is GunConfigurationFireModeSpam:
			var spam: GunConfigurationFireModeSpam = mode
			distance = spam.distance
			if spam.distance_time_coefficient:
				distance *= spam.distance_time_coefficient.sample(_time_since_last_shot)
		_:
			assert(false)
			return 0
	return distance
	
func on_shot() -> void:
	_time_since_last_shot = 0
	
func on_succesfull_shot() -> void:
	on_shot()
	_time_since_last_sucessfull_shot = 0
