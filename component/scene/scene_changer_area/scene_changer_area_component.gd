@tool
class_name SceneChangerAreaComponent
extends Node2D

signal triggered

@export var _trigger_object: Node2D
@export var _change_to: SceneChangerComponent.Scene:
	set(value):
		_change_to = value
		_scene_name.text = SceneChangerComponent.Scene.keys()[_change_to]
@export var move_during_transition: Vector2:
	set(value):
		move_during_transition = value
		queue_redraw()
@export var _time_to_change: float
#todo use
@export var _transition_in_scene: PackedScene
@export var _transition_out_scene: PackedScene

@onready var _scene_changer_component: SceneChangerComponent = %SceneChangerComponent
@onready var _scene_name: Label = %SceneName

func _ready() -> void:
	_change_to = _change_to
	move_during_transition = move_during_transition

func _draw() -> void:
	DrawExtended.draw_arrow(self, Vector2.ZERO, move_during_transition, Color.SPRING_GREEN, 3)

func _on_body_entered(body: Node2D) -> void:
	if _trigger_object == body:
		triggered.emit()
		var transition_instance: Node = null
		if _transition_out_scene:
			transition_instance = _transition_out_scene.instantiate()
			add_child(transition_instance)
		await get_tree().create_timer(_time_to_change).timeout
		if transition_instance:
			transition_instance.queue_free()
		_scene_changer_component.change_scene()
