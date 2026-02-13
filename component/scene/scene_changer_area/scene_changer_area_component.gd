@tool
class_name SceneChangerAreaComponent
extends Node2D

signal triggered(component: SceneChangerAreaComponent)

@export var _trigger_object: Node2D
@export var _change_to: SceneChangerComponent.Scene:
	set(value):
		_change_to = value
		if _scene_name:
			_scene_name.text = SceneChangerComponent.Scene.keys()[_change_to]
		if _scene_changer_component:
			_scene_changer_component.change_to = _change_to
@export var move_during_transition: Vector2:
	set(value):
		move_during_transition = value
		queue_redraw()
@export var _transition_in_scene: PackedScene
@export var _transition_out_scene: PackedScene

@onready var _scene_changer_component: SceneChangerComponent = %SceneChangerComponent
@onready var _scene_name: Label = %SceneName

#todo текст шакалит
#todo накладывается навигация со старой сцены
func _ready() -> void:
	_change_to = _change_to
	move_during_transition = move_during_transition
	if _transition_in_scene:
		assert(PackedSceneExtended.is_scene_root_inherited_from_script(_transition_in_scene, SceneTransition))
	if _transition_out_scene:
		assert(PackedSceneExtended.is_scene_root_inherited_from_script(_transition_out_scene, SceneTransition))
		
func _draw() -> void:
	DrawExtended.draw_arrow(self, Vector2.ZERO, move_during_transition, Color.SPRING_GREEN, 3)

func _on_body_entered(body: Node2D) -> void:
	if _trigger_object == body:
		triggered.emit(self)
		await _play_transition(self, SceneTransition.TransitionDirection.OUT)
		var new_scene: Node = _scene_changer_component.change_scene()
		_play_transition(new_scene, SceneTransition.TransitionDirection.IN)

func _play_transition(root: Node, direction: SceneTransition.TransitionDirection) -> void:
	var transition_instance: SceneTransition = null
	var transition: PackedScene = null
	match direction:
		SceneTransition.TransitionDirection.IN:
			transition = _transition_in_scene
		SceneTransition.TransitionDirection.OUT:
			transition = _transition_out_scene
		_:
			assert(false)
	if transition:
		transition_instance = transition.instantiate()
		root.add_child(transition_instance)
		var sig: Signal = transition_instance.play_till_end(direction)
		sig.connect(func() -> void: transition_instance.queue_free() )
		await sig
