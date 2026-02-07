extends StaticBody2D
class_name Bomb

@onready var _interaction_indicator: Node2D = $InteractableComponent/InteractionIndicator
@onready var _navigation_region_updater_component: NavigationRegionUpdaterComponent = %NavigationRegionUpdaterComponent
@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D

static func new_scene() -> Bomb: 
	return (load("res://entity/bomb/bomb.tscn") as PackedScene).instantiate()
	
func _ready() -> void:
	_interaction_indicator.visible = false
	_navigation_region_updater_component.update()
	
func _on_interactable_component_interacted() -> void:
	queue_free()
	_collision_shape_2d.disabled = true
	_navigation_region_updater_component.update()

func _on_interactable_component_is_interactable_changed(is_interactable: bool) -> void:
	_interaction_indicator.visible = is_interactable
