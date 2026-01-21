class_name TweenerTwitchComponent
extends Node

@export var target_node: Node2D
@export var twitch_duration: float = 0.1
@export var twitch_scale: Vector2 = Vector2(1.2, 1.2)
@export_range(0, 360, 1, "radians_as_degrees") var twitch_random_rotation_limit: float = 0.25

@onready var _original_scale: Vector2 = target_node.scale
@onready var _original_rotation: float = target_node.rotation

var _tween: Tween = create_tween()

func twitch() -> void:
	_tween.kill()
	_tween = create_tween()
	var animation_left_time: float = twitch_duration
	if _original_scale != Vector2.ZERO:
		var return_to_original_duration: float = minf(animation_left_time / 6, 0.1)
		do_parallel_tween(_original_scale, _original_rotation, return_to_original_duration)
		animation_left_time -= return_to_original_duration
	var twitch_random_rotation: float = randf_range(
		- twitch_random_rotation_limit / 2,
		twitch_random_rotation_limit / 2
	)
	do_parallel_tween(twitch_scale, twitch_random_rotation, animation_left_time / 2)
	do_parallel_tween(_original_scale, _original_rotation, animation_left_time / 2)
	
func do_parallel_tween(scale: Vector2, rotation: float, duration: float) -> void:
	_tween.tween_property(target_node, "scale", scale, duration)
	_tween.tween_property(target_node, "rotation", rotation, duration)	
