class_name GunPointer
extends RayCast2D

func get_damageable_component_at_pointer() -> DamageableComponent:
	force_raycast_update()
	while is_colliding():
		var collider: Object = get_collider()
		if collider is not DamageableComponent: return
		var damageable: DamageableComponent = collider
		clear_exceptions()
		return damageable
	return null
