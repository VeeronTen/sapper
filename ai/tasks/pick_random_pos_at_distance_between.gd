@tool
extends BTAction
@export var target_1_var: StringName
@export var target_2_var: StringName
@export var distance: float
@export var output_var: StringName
#todo слить с обычным скриптом без between?
func _generate_name() -> String:
	return "PickRandomPosAtDistanceBetween %s and %s [%s]  ➜%s" % [
		target_1_var,
		target_2_var,
		distance,
		LimboUtility.decorate_var(output_var)
		]

func _tick(_delta: float) -> Status:
	var direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var target_1: Variant = blackboard.get_var(target_1_var, null)
	var target_2: Variant = blackboard.get_var(target_2_var, null)
	if not target_1 or not target_2:
		return FAILURE
	var point_between: Vector2 = (target_1.global_position + target_2.global_position) / 2
	var random_pos: Vector2 = point_between + (distance * direction)
	blackboard.set_var(output_var, random_pos)
	return SUCCESS
