class_name Dummy
extends StaticBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var tweener_twitch_component: TweenerTwitchComponent = %TweenerTwitchComponent
@onready var on_hit_particle_component: OnHitParticleComponent = %OnHitParticleComponent
@onready var navigation_region_updater_component: NavigationRegionUpdaterComponent = $NavigationRegionUpdaterComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

static func new_scene() -> Dummy: 
	return (load("res://entity/dummy/dummy.tscn") as PackedScene).instantiate()
	
func _ready() -> void:
	navigation_region_updater_component.update()

func _on_health_component_dead() -> void:
	queue_free()
	collision_shape_2d.disabled = true
	navigation_region_updater_component.update()
	
#fixme статичный объект + надо будет ребейкать навигацию
func _on_damageable_component_air_took_damage() -> void:
	tweener_twitch_component.twitch()
	on_hit_particle_component.emit()
