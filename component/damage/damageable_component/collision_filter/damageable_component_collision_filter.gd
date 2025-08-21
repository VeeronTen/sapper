class_name DamageableComponentCollisionFilter
extends Resource

@export var debug_color_damaging: Color
@export var debug_color_damageable: Color

func is_compatible_with(other: DamageableComponentCollisionFilter) -> bool:
	assert(false, "abstract")
	return false
