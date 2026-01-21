class_name Dummy
extends CharacterBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var tweener_twitch_component: TweenerTwitchComponent = %TweenerTwitchComponent

static func new_scene() -> Dummy: 
	return (load("res://entity/dummy/dummy.tscn") as PackedScene).instantiate()
	
func _on_health_component_dead() -> void:
	queue_free()

func _on_damageable_component_air_took_damage() -> void:
	tweener_twitch_component.twitch()
