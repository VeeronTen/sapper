@tool
extends BTAction
@export var target_var: StringName
@export var distance: float
@export var output_var: StringName

func _generate_name() -> String:
	return "PickRandomPosAtDistance \"%s\" [%s]  ➜%s" % [
		target_var,
		distance,
		LimboUtility.decorate_var(output_var)
		]

func _tick(_delta: float) -> Status:
	var direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var target: Node2D = blackboard.get_var(target_var, null)
	if not target:
		return FAILURE
	var random_pos: Vector2 = target.global_position + (distance * direction)
	blackboard.set_var(output_var, random_pos)
	return SUCCESS
