class_name HealthComponent
extends Node2D

signal dead

@export var show_debug_healthbar: bool = false
@export var _initial_value: float
var _current_value: float

func _ready() -> void:
	_current_value = _initial_value
	assert(_current_value > 0.0, "initial health mast be positive")
	
func take_damage(damage: Damage) -> void:
	_current_value -= damage.value
	queue_redraw()
	if _current_value <= 0.0: dead.emit()	
	
func get_current_value() -> float:
	return _current_value

func _draw() -> void:
	if not show_debug_healthbar: return
	var to_left_offset: float = -_initial_value / 2
	draw_rect(Rect2(to_left_offset, 0, _initial_value, 4), Color.GREEN, false)
	draw_rect(Rect2(to_left_offset, 0, _current_value, 4), Color.GREEN)
