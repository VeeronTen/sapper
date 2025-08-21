@tool
class_name CollisionsRecolorer
extends Node

@export var collisions_color: Color:
	set(value):
		collisions_color = value
		_recolor_debug_areas()
@export var target: Node

#todo унести в плагин
func _ready() -> void:
	if Engine.is_editor_hint: _recolor_debug_areas()

func _recolor_debug_areas() -> void:
	for child: Node in target.get_children():
		if child is CollisionShape2D:
			var collision: CollisionShape2D = child
			collision.debug_color = collisions_color
