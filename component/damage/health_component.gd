class_name HealthComponent
extends Node

signal dead

@export var _initial_value: float
var _current_value: float

func _ready() -> void:
	_current_value = _initial_value
	assert(_current_value > 0.0, "initial health mast be positive")
	
func take_damage(damage: Damage) -> void:
	_current_value -= damage.value
	if _current_value <= 0.0: dead.emit()	
	
func get_current_value() -> float:
	return _current_value
