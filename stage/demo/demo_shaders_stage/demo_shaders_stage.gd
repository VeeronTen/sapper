extends Node2D

@onready var _input_source_component: InputSourceComponent = %InputSourceComponent

func _on_scene_changer_area_component_triggered(component: SceneChangerAreaComponent) -> void:
	_input_source_component.move_direction = component.move_during_transition
	_input_source_component.disable()
