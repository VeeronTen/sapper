extends Node2D
#todo backBufferCopy
#todo локализация
#todo сохранение загрузка
#todo канвас группа
#todo Perspective in Top down
#todo особая зона на врагах, в которой хитмаркеры появляются
#todo Прицел с искривлением пространства
#todo что-то было про отельный файл с ссылками на сцены, чтобы их пути не хардкодить
#todo поправить коллизии для нав агентов

@onready var _sapper: Sapper = %Sapper
@onready var _light_gun: LightGun = %LightGun
@onready var _regular_phantom_camera_2d: PhantomCamera2D = $RegularPhantomCamera2D
@onready var _world_edge_phantom_camera_2d: PhantomCamera2D = $WorldEdge/WorldEdgePhantomCamera2D

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
	
func _on_demo_controls_is_moving_changed(is_moving: bool) -> void:
	_sapper.is_moving = is_moving

func _on_demo_controls_move_direction_changed(direction: Vector2) -> void:
	_sapper.move_direction = direction

func _on_demo_controls_pointer_position_changed(pointer: Vector2) -> void:
	_light_gun.pointer_position = pointer
	_sapper.watch_position = pointer

func _on_demo_controls_pointer_click(_pointer: Vector2) -> void:
	_light_gun.shoot()

func _on_spawn_dummy_timer_timeout() -> void:
	var dummy: Dummy = Dummy.new_scene()
	var random_x: float = _rng.randf_range(-1.0, 1.0)
	var random_y: float = _rng.randf_range(-1.0, 1.0)
	var direction: Vector2 = Vector2(random_x, random_y).normalized()
	dummy.global_position = _sapper.global_position + direction * 40
	add_child(dummy)

func _on_demo_controls_roll_pressed() -> void:
	_sapper.try_to_roll()


func _on_zoom_out_area_body_entered(body: Node2D) -> void:
	if body.name == "Sapper":
		_regular_phantom_camera_2d.priority = 0
		_world_edge_phantom_camera_2d.priority = 1

func _on_zoom_out_area_body_exited(body: Node2D) -> void:
		if body.name == "Sapper":
			_regular_phantom_camera_2d.priority = 1
			_world_edge_phantom_camera_2d.priority = 0
