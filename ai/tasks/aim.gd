@tool
extends BTAction
@export var target_var: StringName
@export var progress_var: StringName
@export var max_distance: float
@export var duration: float
@export var reset_target_at_fail: bool = true

var _time_passed: float = 0.0

func _generate_name() -> String:
	return "Aim to %s [%s;%s] -> %s" % [
		target_var,
		max_distance,
		duration,
		LimboUtility.decorate_var(progress_var)
		]

func _tick(delta: float) -> Status:
	var target: Variant = blackboard.get_var(target_var, null)
	if not target:
		_process_failure()
		return FAILURE
	if target is Node2D:
		target = target.global_position
	var target_pos: Vector2 = target
	var agent_node_2d: Node2D = agent as Node2D
	var distance_to_target: float = target_pos.distance_to(agent_node_2d.global_position)
	if distance_to_target > max_distance:
		_process_failure()
		return FAILURE
	_time_passed += delta
	if _time_passed > duration:
		blackboard.set_var(progress_var, 1.0)
		return SUCCESS
	else: 
		blackboard.set_var(progress_var, _time_passed / duration)
		return RUNNING
		
func _exit() -> void:
	_time_passed = 0.0
	blackboard.set_var(progress_var, 0.0)
	
func _process_failure() -> void:
	if reset_target_at_fail: 
		blackboard.set_var(target_var, null)
	blackboard.set_var(progress_var, 0.0)
