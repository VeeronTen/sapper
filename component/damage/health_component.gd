@tool
class_name HealthComponent
extends Node2D

signal dead

@export var show_debug_healthbar: bool = false:
	set(value):
		show_debug_healthbar = value
		queue_redraw()
		
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

#todo сделать сценой, чтобы порядок отрисовки сделать. или без сцены
func _draw() -> void:
	if not show_debug_healthbar: return
	var box_color: Color
	if _current_value > 0: box_color = Color.GREEN 
	else: box_color = Color.RED
	const box_width: float = 10
	const box_height: float = 4
	draw_rect(Rect2(-box_width / 2, -box_height / 2, box_width, box_height), box_color, false)
	draw_rect(Rect2(-box_width / 2, -box_height / 2, _current_value / _initial_value * box_width, box_height), box_color)
