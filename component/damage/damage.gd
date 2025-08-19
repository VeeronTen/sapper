class_name Damage
extends Node

var value: float:
	set(new_value):
		assert(new_value >= 0.0, "damage cant be < 0")
		value = new_value
