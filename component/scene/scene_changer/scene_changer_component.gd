class_name SceneChangerComponent
extends Node

enum Scene {
	DEMO_HUB,
	DEMO_ORIGINAL,
	DEMO_SHADERS,
	DEMO_SHOOTING_RANGE,
}

@export var change_to: Scene

func _scene_to_uid(scene: Scene) -> String:
	match scene:
		Scene.DEMO_HUB: return "uid://dlilykokhgx8k"
		Scene.DEMO_ORIGINAL: return "uid://kqkvasn678ry"
		Scene.DEMO_SHADERS: return "uid://cu6qm7l1y18nx"
		Scene.DEMO_SHOOTING_RANGE: return "uid://c430veyjgx5k1"
		_: return ""

func change_scene() -> Node:
	var uid: String = _scene_to_uid(change_to)
	var packed_scene: PackedScene = load(uid)
	var new_scene: Node = packed_scene.instantiate()
	var old_scene: Node = get_tree().current_scene
	var tree: SceneTree = get_tree()
	tree.root.remove_child(old_scene) 
	tree.root.add_child(new_scene)
	tree.current_scene = new_scene
	old_scene.queue_free()
	return new_scene
