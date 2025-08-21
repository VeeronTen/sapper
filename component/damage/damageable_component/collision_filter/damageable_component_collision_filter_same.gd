class_name DamageableComponentCollisionFilterSame
extends DamageableComponentCollisionFilter

func is_compatible_with(other: DamageableComponentCollisionFilter) -> bool:
	return self == other
