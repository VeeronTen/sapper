extends Node2D
#todo backBufferCopy
#todo локализация
#todo сохранение загрузка
#todo канвас группа
#todo Perspective in Top down
#todo особая зона на врагах, в которой хитмаркеры появляются
#todo Прицел с искривлением пространства
#todo поправить коллизии для нав агентов
#todo порядок отрисовки всех

@export var pointer_camera_affect: float = 0.4
@export var pointer_min_distance_to_offset: float = 25
@export var pointer_max_distance_to_offset: float = 40
@export var pointer_max_zoom: float = 7
@export var pointer_min_zoom: float = 6.6

@onready var _sapper: Sapper = %Sapper
@onready var _regular_phantom_camera_2d: PhantomCamera2D = $RegularPhantomCamera2D
@onready var _world_edge_phantom_camera_2d: PhantomCamera2D = $WorldEdge/WorldEdgePhantomCamera2D
@onready var navigation_region_2d: NavigationRegion2D = $Map/NavigationRegion2D

var click_is_holded: bool = false

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
	
func _physics_process(delta: float) -> void:
	if click_is_holded:
		_sapper.try_to_shoot(true)
	
func _on_demo_controls_is_moving_changed(is_moving: bool) -> void:
	_sapper.is_moving = is_moving

func _on_demo_controls_move_direction_changed(direction: Vector2) -> void:
	_sapper.move_direction = direction

func _on_demo_controls_pointer_position_changed(pointer: Vector2) -> void:
	_sapper.watch_position = pointer
	_apply_pointer_to_regular_camera(pointer)

func _on_demo_controls_pointer_click(_pointer: Vector2) -> void:
	_sapper.try_to_shoot(false)

func _on_demo_controls_pointer_pressed(is_pressed: bool) -> void:
	click_is_holded = is_pressed
	
func _on_spawn_dummy_timer_timeout() -> void:
	var dummy: Dummy = Dummy.new_scene()
	var random_x: float = _rng.randf_range(-1.0, 1.0)
	var random_y: float = _rng.randf_range(-1.0, 1.0)
	var direction: Vector2 = Vector2(random_x, random_y).normalized()
	dummy.global_position = _sapper.global_position + direction * 40
	navigation_region_2d.add_child(dummy)

func _on_demo_controls_roll_pressed() -> void:
	_sapper.try_to_roll()
	
func _on_demo_controls_interact_pressed() -> void:
	_sapper.try_to_interact()

func _on_demo_controls_drop_pressed() -> void:
	_sapper.try_to_drop()

func _on_zoom_out_area_body_entered(body: Node2D) -> void:
	if body.name == "Sapper":
		_regular_phantom_camera_2d.priority = 0
		_world_edge_phantom_camera_2d.priority = 1

func _on_zoom_out_area_body_exited(body: Node2D) -> void:
		if body.name == "Sapper":
			_regular_phantom_camera_2d.priority = 1
			_world_edge_phantom_camera_2d.priority = 0
			
#fixme довольно неудобно вышло
func _apply_pointer_to_regular_camera(pointer: Vector2) -> void:
	var offset: Vector2 = (pointer - _sapper.global_position) * pointer_camera_affect
	offset = Vector2.ZERO if offset.length() < pointer_min_distance_to_offset else offset.limit_length(pointer_max_distance_to_offset)
	var zoom_factor: float = remap(offset.length(), pointer_min_distance_to_offset, pointer_max_distance_to_offset, pointer_max_zoom, pointer_min_zoom)
	_regular_phantom_camera_2d.zoom = Vector2.ONE * clampf(zoom_factor, pointer_min_zoom, pointer_max_zoom)
	_regular_phantom_camera_2d.follow_offset = offset
