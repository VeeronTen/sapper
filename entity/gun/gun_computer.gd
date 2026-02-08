class_name GunComputer
extends Node

@export var _configuration: GunConfiguration

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _time_since_last_shot: float = 0
var _time_since_last_sucessfull_shot: float = 0

func _process(delta: float) -> void:
	_time_since_last_shot += delta
	_time_since_last_sucessfull_shot += delta
	
func can_shoot() -> bool:
	match _configuration.fire_mode:
		var mode when mode is GunConfigurationFireModeConstant:
			var constant: GunConfigurationFireModeConstant = mode
			return _time_since_last_shot > 1 / constant.bps
		var mode when mode is GunConfigurationFireModeAuto:
			var auto: GunConfigurationFireModeAuto = mode
			return true #todo
		var mode when mode is GunConfigurationFireModeSpam:
			var spam: GunConfigurationFireModeSpam = mode
			return true
		_:
			assert(false)
			return false

func get_damage() -> Damage:
	if _configuration.damage_spam_override:
		var real_damage: Damage = _configuration.damage.duplicate()
		real_damage.value = _configuration.damage_spam_override.sample(_time_since_last_sucessfull_shot)	
		return real_damage
	else:
		return _configuration.damage

func get_spread() -> float:
	var spread: float
	match _configuration.fire_mode:
		var mode when mode is GunConfigurationFireModeConstant:
			var constant: GunConfigurationFireModeConstant = mode
			spread = constant.spread
		var mode when mode is GunConfigurationFireModeAuto:
			var auto: GunConfigurationFireModeAuto = mode
			spread = 10  #todo
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
	return _configuration.max_distance
	
func on_shot() -> void:
	_time_since_last_shot = 0
	
func on_succesfull_shot() -> void:
	on_shot()
	_time_since_last_sucessfull_shot = 0
