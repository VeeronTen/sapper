class_name PackedSceneExtended

static func get_scene_root_class_script(scene: PackedScene) -> Script:
	var state: SceneState = scene.get_state()
	for i: int in range(state.get_node_property_count(0)):
		if state.get_node_property_name(0, i) == "script":
			return state.get_node_property_value(0, i)
	return null

static func is_scene_root_inherited_from_script(scene: PackedScene, target_script: Script) -> bool:
	var script: Script = get_scene_root_class_script(scene)
	if script:
		return is_script_inherited(script, target_script)
	return false

static func is_script_inherited(script: Script, potential_parent_script: Script) -> bool:
	var current_script: Script = script
	while current_script != null:
		if current_script == potential_parent_script: 
			return true
		current_script = current_script.get_base_script()
	return false
