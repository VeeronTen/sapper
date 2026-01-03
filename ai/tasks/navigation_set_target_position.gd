@tool
extends BTAction

@export var target_var: StringName

func _generate_name() -> String:
	return "Navigation set target position from %s" % [
		LimboUtility.decorate_var(target_var)
		]

func _tick(_delta: float) -> Status:
	var nav_agent: NavigationAgent2D = blackboard.get_var("nav_agent")
	var target: Variant = blackboard.get_var(target_var)
	if target is Node2D:
		target = target.global_position
	nav_agent.target_position = target
	return SUCCESS
