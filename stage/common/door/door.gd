extends StaticBody2D

@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var _open_interactable_component: InteractableComponent = %OpenInteractableComponent
@onready var _close_interactable_component: InteractableComponent = %CloseInteractableComponent
@onready var _navigation_region_updater_component: NavigationRegionUpdaterComponent = %NavigationRegionUpdaterComponent
@onready var image: Node2D = %Image

var _opened: bool = false:
	set(value):
		_opened = value
		image.visible = not _opened
		_collision_shape_2d.disabled = _opened
		_open_interactable_component.monitorable = not _opened
		_close_interactable_component.monitorable = _opened
		_navigation_region_updater_component.update()

func _ready() -> void:
	_opened = _opened
	_open_interactable_component.visible = false
	_close_interactable_component.visible = false

func _on_open_interactable_component_interacted() -> void:
	_opened = true

func _on_open_interactable_component_is_interactable_changed(is_interactable: bool) -> void:
	_open_interactable_component.visible = is_interactable

func _on_close_interactable_component_interacted() -> void:
	_opened = false

func _on_close_interactable_component_is_interactable_changed(is_interactable: bool) -> void:
	_close_interactable_component.visible = is_interactable
