extends CharacterBody2D

@export var speed: float = 30
@export_range(0, 90, 1, "radians") var max_move_skew: float

@onready var _sprites: Node2D = %Sprites
@onready var _navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var _bt_player: BTPlayer = $BTPlayer
@onready var _damaging_ray_component: DamagingRayComponent = $DamagingRayComponent
@onready var _animation_tree: AnimationTree = %AnimationTree

var _max_registered_horizontal_velocity: float = 0.0
var _blackboard_enemy_target: Node2D:
	set(value):
		_blackboard_enemy_target = value
		if is_instance_valid(value):
			_animation_tree.set("parameters/Transition/transition_request", "angry")
		else: 		
			_animation_tree.set("parameters/Transition/transition_request", "smile")

#todo заюзать анимацию говорения
func _ready() -> void:
	_bt_player.blackboard.set_var("nav_agent", _navigation_agent_2d)
	_bt_player.blackboard.bind_var_to_property(&"enemy_target", self, "_blackboard_enemy_target")
	
func _process(delta: float) -> void:
	queue_redraw()
	var target_skew: float = max_move_skew if velocity.x > 0 else -max_move_skew
	target_skew *= absf(velocity.x) / _max_registered_horizontal_velocity
	_sprites.skew = lerpf(_sprites.skew, target_skew, delta)
	
func _physics_process(_delta: float) -> void:
	_sprites.scale.x = 1 if velocity.x < 0 else -1
	_max_registered_horizontal_velocity = max(_max_registered_horizontal_velocity, absf(velocity.x))
	
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
