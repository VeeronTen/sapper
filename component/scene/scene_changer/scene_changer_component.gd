class_name SceneChangerComponent
extends Node

enum Scene {
	NEXT,
	DEMO_HUB,
	DEMO_ORIGINAL,
	DEMO_SHADERS,
	DEMO_SHOOTING_RANGE,
}

@export var _scene_sequence: SceneSequence
@export var change_to: Scene

var _change_to_uid: String:
	get():
		if change_to == Scene.NEXT:
			return _get_uid_of_next_scene_in_sequence()
		return _scene_to_uid_map[change_to]
		
var _scene_to_uid_map: Dictionary  = {
	Scene.DEMO_HUB: 			"uid://dlilykokhgx8k",
	Scene.DEMO_ORIGINAL:   		"uid://kqkvasn678ry",
	Scene.DEMO_SHADERS:      	"uid://cu6qm7l1y18nx",
	Scene.DEMO_SHOOTING_RANGE: 	"uid://c430veyjgx5k1"
}
var _uid_to_scene_map: Dictionary  = {}

func _ready() -> void:
	for scene: Scene in _scene_to_uid_map:
		_uid_to_scene_map[_scene_to_uid_map[scene]] = scene
	prints("ready", Scene.keys()[change_to])

func change_scene() -> Node:
	var uid: String = _change_to_uid
	var packed_scene: PackedScene = load(uid)
	var new_scene: Node = packed_scene.instantiate()
	var old_scene: Node = get_tree().current_scene
	var tree: SceneTree = get_tree()
	tree.root.remove_child(old_scene) 
	tree.root.add_child(new_scene)
	tree.current_scene = new_scene
	old_scene.queue_free()
	return new_scene

func _get_uid_of_next_scene_in_sequence() -> String:
	var current_uid_int: int = ResourceLoader.get_resource_uid(get_tree().current_scene.scene_file_path)
	var current_uid_string: String = ResourceUID.id_to_text(current_uid_int)
	var current_scene: Scene = _uid_to_scene_map[current_uid_string]
	var current_index: int = _scene_sequence.scene_sequence.find(current_scene)
	var next_scene: Scene = _scene_sequence.scene_sequence[current_index + 1]
	return _scene_to_uid_map[next_scene]
