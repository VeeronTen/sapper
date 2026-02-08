class_name Dummy
extends StaticBody2D

@onready var _tweener_twitch_component: TweenerTwitchComponent = %TweenerTwitchComponent
@onready var _on_hit_particle_component: OnHitParticleComponent = %OnHitParticleComponent
@onready var _navigation_region_updater_component: NavigationRegionUpdaterComponent = $NavigationRegionUpdaterComponent
@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D

static func new_scene() -> Dummy: 
	return (load("uid://c7mytol7o1133") as PackedScene).instantiate()
	
func _ready() -> void:
	_navigation_region_updater_component.update()

func _on_health_component_dead() -> void:
	queue_free()
	_collision_shape_2d.disabled = true
	_navigation_region_updater_component.update()
	
#fixme статичный объект + надо будет ребейкать навигацию
func _on_damageable_component_air_took_damage() -> void:
	_tweener_twitch_component.twitch()
	_on_hit_particle_component.emit()
