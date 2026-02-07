@tool
class_name GunPointer
extends RayCast2D

@export var marker: Texture2D: 
	set(value):
		marker = value
		if sprite_2d:
			sprite_2d.texture = marker

@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	marker = marker
	
func get_damageable_component_at_pointer() -> DamageableComponent:
	force_raycast_update()
	while is_colliding():
		var collider: Object = get_collider()
		if collider is not DamageableComponent: return
		var damageable: DamageableComponent = collider
		clear_exceptions()
		return damageable
	return null
