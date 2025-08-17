class_name Sapper
extends CharacterBody2D

@export var walk_speed: float = 2700.0

var direction: Vector2 = Vector2.ZERO
var is_moving: bool = false

func _physics_process(delta: float) -> void:
	velocity = direction * walk_speed * delta
	move_and_slide()
