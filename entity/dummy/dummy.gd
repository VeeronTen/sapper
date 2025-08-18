class_name Dummy
extends StaticBody2D

@onready var health_component: HealthComponent = %HealthComponent
	
static func new_scene() -> Dummy: 
	return (load("res://entity/dummy/dummy.tscn") as PackedScene).instantiate()
	
func _on_health_component_dead() -> void:
	queue_free()
