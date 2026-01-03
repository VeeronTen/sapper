@tool
extends BTAction

@export var speed: float

func _generate_name() -> String:
	return "Navigation go with speed %s" % [
		speed
		]

func _tick(_delta: float) -> Status:
	var nav_agent: NavigationAgent2D = blackboard.get_var("nav_agent")
	
	if nav_agent.is_navigation_finished():
		return SUCCESS
	else:
		var agent_cb2d: CharacterBody2D = agent as CharacterBody2D
		agent_cb2d.velocity = agent_cb2d.to_local(nav_agent.get_next_path_position()).normalized() * speed
		agent_cb2d.move_and_slide()
		return RUNNING
