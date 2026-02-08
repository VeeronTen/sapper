class_name SceneChangerComponent
extends Node

enum Scene {
	DEMO_STAGE
}

@export var change_to: Scene

func _scene_to_uid(scene: Scene) -> String:
	match scene:
		Scene.DEMO_STAGE: return "uid://kqkvasn678ry"
		_: return ""

func change_scene() -> void:
	var uid: String = _scene_to_uid(change_to)
	var packed_scene: PackedScene = load(uid)
	var new_scene: Node = packed_scene.instantiate()
	var old_scene: Node = get_tree().current_scene
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	old_scene.queue_free()
