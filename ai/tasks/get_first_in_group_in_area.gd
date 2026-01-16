@tool
extends BTAction

@export var group: StringName
@export var area: BBNode
@export var output_var: StringName = &"target"

func _generate_name() -> String:
	return "GetFirstNodeInGroup In Area \"%s\"  ➜%s" % [
		group,
		LimboUtility.decorate_var(output_var)
		]

func _tick(_delta: float) -> Status:
	var unwrapped_area: Area2D = area.get_value(scene_root, blackboard)
	var all_bodies: Array[Node2D] = unwrapped_area.get_overlapping_bodies()
	var target_index: int = all_bodies.find_custom(
		func(body: Node2D) -> bool: return body.is_in_group(group)
	)
	if target_index != -1:
		blackboard.set_var(output_var, all_bodies[target_index])
		return SUCCESS
	return FAILURE
