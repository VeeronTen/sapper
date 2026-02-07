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
	if _configuration.damage_spam_override: 
		return true
	return _time_since_last_shot > 1 / _configuration.bps

func get_damage() -> Damage:
	if _configuration.damage_spam_override:
		var real_damage: Damage = _configuration.damage.duplicate()
		real_damage.value = _configuration.damage_spam_override.sample(_time_since_last_sucessfull_shot)	
		return real_damage
	else:
		return _configuration.damage

func get_spread() -> float:
	var samled_spread: float = _configuration.spread_spam_override.sample(_time_since_last_shot)
	return _rng.randf_range(-samled_spread/2, samled_spread/2)

func get_distance() -> float:
	return _configuration.max_distance
	
func on_shot() -> void:
	_time_since_last_shot = 0
	
func on_succesfull_shot() -> void:
	on_shot()
	_time_since_last_sucessfull_shot = 0
