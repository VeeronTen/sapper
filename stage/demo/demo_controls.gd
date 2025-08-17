extends Node2D

signal move_direction_changed(direction: Vector2)
signal is_moving_changed(is_moving: bool)
signal pointer_position_changed(pointer: Vector2)

var _prev_move_direction: Vector2 = Vector2.ZERO
var _prev_is_moving: bool = false

func _process(delta: float) -> void:
	pointer_position_changed.emit(get_global_mouse_position())
	
func _physics_process(_delta: float) -> void:
	var move_direction: Vector2 = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	if move_direction != _prev_move_direction:
		move_direction_changed.emit(move_direction)
		_prev_move_direction = move_direction
		var is_moving: bool = move_direction != Vector2.ZERO
		if is_moving != _prev_is_moving:
			is_moving_changed.emit(is_moving)
			_prev_is_moving = is_moving
