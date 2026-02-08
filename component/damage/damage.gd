@tool
class_name Damage
extends Resource

@export var value: float:
	set(new_value):
		assert(new_value >= 0.0, "damage cant be < 0")
		if value != new_value:
			value = new_value
			emit_changed()

func _init() -> void:
	call_deferred("_validate")
	
func _validate() -> void:
	value = value
