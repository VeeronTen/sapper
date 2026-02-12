class_name SapperInputMapper
extends Node

@export var _input_source: InputSourceComponent
@export var _sapper: Sapper

func _ready() -> void:
	_input_source.pointer_position_changed.connect(_on_pointer_position_changed)
	_input_source.is_moving_changed.connect(_on_is_moving_changed)
	_input_source.move_direction_changed.connect(_on_move_direction_changed)
	_input_source.pointer_click.connect(_on_pointer_click)
	_input_source.roll_pressed.connect(_on_roll_pressed)
	_input_source.interact_pressed.connect(_on_interact_pressed)
	_input_source.drop_pressed.connect(_on_drop_pressed)

func _physics_process(_delta: float) -> void:
	if _input_source.pointer_pressed:
		_sapper.try_to_shoot(true)
	
func _on_pointer_position_changed(pointer: Vector2) -> void:
	_sapper.watch_position = pointer
	
func _on_is_moving_changed(is_moving: bool) -> void:
	_sapper.is_moving = is_moving

func _on_move_direction_changed(direction: Vector2) -> void:
	_sapper.move_direction = direction

func _on_pointer_click(_pointer: Vector2) -> void:
	_sapper.try_to_shoot(false)

func _on_roll_pressed() -> void:
	_sapper.try_to_roll()
	
func _on_interact_pressed() -> void:
	_sapper.try_to_interact()

func _on_drop_pressed() -> void:
	_sapper.try_to_drop()
