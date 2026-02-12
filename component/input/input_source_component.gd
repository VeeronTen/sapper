class_name InputSourceComponent
extends Node2D

signal move_direction_changed(direction: Vector2)
signal is_moving_changed(is_moving: bool)
signal pointer_position_changed(pointer: Vector2)
signal pointer_pressed(is_pressed: bool)
signal pointer_click(pointer: Vector2)
signal roll_pressed
signal interact_pressed
signal drop_pressed

var move_direction: Vector2 = Vector2.ZERO:
	set(value):
		if move_direction != value:
			move_direction = value
			move_direction_changed.emit(move_direction)
			is_moving = move_direction != Vector2.ZERO

var is_moving: bool = false:
	set(value):
		if is_moving != value:
			is_moving = value
			is_moving_changed.emit(is_moving)

var pointer_is_pressed: bool:
	set(value):
		if pointer_is_pressed != value:
			pointer_is_pressed = value
			pointer_pressed.emit(pointer_is_pressed)

func _process(_delta: float) -> void:
	pointer_position_changed.emit(get_global_mouse_position())
	pointer_is_pressed = Input.is_action_pressed("pointer_click")
	
func _physics_process(_delta: float) -> void:
	move_direction = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed:
			_handle_mouse_input(mouse_event)
	elif event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed and not key_event.echo:
			_handle_key_input(key_event)

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	match event.button_index:
		MOUSE_BUTTON_LEFT: 
			pointer_click.emit(get_global_mouse_position())
			
func _handle_key_input(event: InputEventKey) -> void:
	if event.is_action("roll"):
		roll_pressed.emit()
	elif event.is_action("interact"):
		interact_pressed.emit()
	elif event.is_action("drop"):
		drop_pressed.emit()
	
