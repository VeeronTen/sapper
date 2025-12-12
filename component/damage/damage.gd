@tool
class_name Damage
extends Resource

@export var value: float:
	set(new_value):
		assert(new_value >= 0.0, "damage cant be < 0")
		value = new_value
		
@export var is_continuous: bool
