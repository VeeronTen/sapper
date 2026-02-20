extends Node2D
#todo локализация
#todo сохранение загрузка
#todo особая зона на врагах, в которой хитмаркеры появляются
#todo Прицел с искривлением пространства
#todo поправить коллизии для нав агентов
#todo z индекс в зависимость от y
#todo тряска приходьбе, особенно по диагонали

@onready var _sapper: Sapper = %Sapper
@onready var _world_edge_phantom_camera_2d: PhantomCamera2D = $WorldEdge/WorldEdgePhantomCamera2D
@onready var _navigation_region_2d: NavigationRegion2D = $Map/NavigationRegion2D
@onready var _scene_changer_area_component: SceneChangerAreaComponent = %SceneChangerAreaComponent
@onready var _input_source_component: InputSourceComponent = $Input/InputSourceComponent

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_spawn_dummy_timer_timeout() -> void:
	var dummy: Dummy = Dummy.new_scene()
	var random_x: float = _rng.randf_range(-1.0, 1.0)
	var random_y: float = _rng.randf_range(-1.0, 1.0)
	var direction: Vector2 = Vector2(random_x, random_y).normalized()
	dummy.global_position = _sapper.global_position + direction * 40
	_navigation_region_2d.add_child(dummy)

func _on_zoom_out_area_body_entered(body: Node2D) -> void:
	if body.name == "Sapper":
		_world_edge_phantom_camera_2d.priority = 1

func _on_zoom_out_area_body_exited(body: Node2D) -> void:
		if body.name == "Sapper":
			_world_edge_phantom_camera_2d.priority = -1

func _on_scene_changer_area_component_triggered(component: SceneChangerAreaComponent) -> void:
	_input_source_component.move_direction = _scene_changer_area_component.move_during_transition
	_input_source_component.disable()
