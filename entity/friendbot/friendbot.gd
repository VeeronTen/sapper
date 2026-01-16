extends CharacterBody2D

@export var speed: float = 30

@onready var _sprite_2d: Sprite2D = $Sprite2D
@onready var _navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var _bt_player: BTPlayer = $BTPlayer
@onready var _damaging_ray_component: DamagingRayComponent = $DamagingRayComponent

func _ready() -> void:
	_bt_player.blackboard.set_var("nav_agent", _navigation_agent_2d)
	
func _process(_delta: float) -> void:
	queue_redraw()
	
func _physics_process(_delta: float) -> void:
	_sprite_2d.flip_h = velocity.x < 0
	
func _draw() -> void:
	var target: Variant = _bt_player.blackboard.get_var("enemy_target")
	var aim_progress: float = _bt_player.blackboard.get_var("aim_progress")
	if not target or not aim_progress:
		return
	var color: Color = Color.BLUE.lerp(Color.RED, aim_progress)
	var width: float = 10.0 * aim_progress
	draw_line(Vector2.ZERO, to_local(target.global_position), color, width)
	
func _on_area_2d_aggro_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var current_enemy: Variant = _bt_player.blackboard.get_var("enemy_target", null)
		if current_enemy != null:
			return
		_bt_player.blackboard.set_var("enemy_target", body)

func shoot_target() -> void:
	var target: Node2D = _bt_player.blackboard.get_var("enemy_target")
	if not target:
		return
	var distance: float = global_position.distance_to(target.global_position)
	_damaging_ray_component.look_at(target.global_position)
	_damaging_ray_component.shoot(distance)
