@tool 
class_name CameraComponent
extends Node2D

@export var _follow_target: Node2D:
	set(value):
		if _phantom_camera_2d:
			_phantom_camera_2d.follow_target = value
			_follow_target = _phantom_camera_2d.follow_target
		else:
			_follow_target = value
@export var _priority: int = 1:
	set(value):
		if _phantom_camera_2d:
			_phantom_camera_2d.priority = value
			_priority = _phantom_camera_2d.priority
		else:
			_priority = value
@export var _watch_point_offset_in_screen_sizes: float = 0.2
@export var _watch_point_zoom: float = 0.85
@export var _watch_point_deadzone_in_screen_sizes: float = 0.3

@onready var _phantom_camera_2d: PhantomCamera2D = $PhantomCamera2D
@onready var _initial_zoom: Vector2 = _phantom_camera_2d.zoom

func _ready() -> void:
	_follow_target = _follow_target
	_priority = _priority

func change_watch_point(point: Vector2) -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	var screen_pos_raw: Vector2 = (get_canvas_transform() * point / screen_size).clamp(Vector2.ZERO, Vector2.ONE)
	var centered_pos: Vector2 = screen_pos_raw - Vector2(0.5, 0.5)
	var deadzone_half: float = _watch_point_deadzone_in_screen_sizes / 2.0
	var remapped_pos: Vector2 = Vector2(
		MathExtended.remap_by_deadzone(centered_pos.x, 0.0, 0.5, deadzone_half),
		MathExtended.remap_by_deadzone(centered_pos.y, 0.0, 0.5, deadzone_half)
	)
	var influence_weight: float = clamp(remapped_pos.length() * 2.0, 0.0, 1.0)
	_phantom_camera_2d.zoom = _initial_zoom.lerp(_initial_zoom * _watch_point_zoom, influence_weight)	
	# 6. Применяем Смещение (Offset)
	# Множитель 2 возвращает нормализованные координаты к размеру экрана
	var target_offset: Vector2 = remapped_pos * _watch_point_offset_in_screen_sizes * screen_size * 2.0
	_phantom_camera_2d.follow_offset = target_offset / _phantom_camera_2d.zoom
