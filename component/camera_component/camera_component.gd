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
@export var _point_camera_affect: float = 0.4
@export var _point_min_distance_to_offset: float = 25
@export var _point_max_distance_to_offset: float = 40
@export var _point_max_zoom: float = 7
@export var _point_min_zoom: float = 6.6

@onready var _phantom_camera_2d: PhantomCamera2D = $PhantomCamera2D

func _ready() -> void:
	_follow_target = _follow_target
	_priority = _priority
	
#fixme довольно неудобно вышло, брать координаты от экрана а не сапера
func change_watch_point(point: Vector2) -> void:
	if not _follow_target: 
		return
	var offset: Vector2 = (point - _follow_target.global_position) * _point_camera_affect
	offset = Vector2.ZERO if offset.length() < _point_min_distance_to_offset else offset.limit_length(_point_max_distance_to_offset)
	var zoom_factor: float = remap(offset.length(), _point_min_distance_to_offset, _point_max_distance_to_offset, _point_max_zoom, _point_min_zoom)
	_phantom_camera_2d.zoom = Vector2.ONE * clampf(zoom_factor, _point_min_zoom, _point_max_zoom)
	_phantom_camera_2d.follow_offset = offset
