class_name InteractingComponent
extends Area2D

@export var _can_interact_with_tags: Array[String]

signal can_interact_changed(can_interact: bool)

var _can_interact: bool:
	set(value):
		if _can_interact != value:
			can_interact_changed.emit(value)
		_can_interact = value
var _targets: Array[InteractableComponent] = []

var _interactable_target: InteractableComponent:
	set(value):
		if value == _interactable_target:
			return
		if is_instance_valid(_interactable_target):
			_interactable_target.set_is_interactable(false)
		_interactable_target = value
		if is_instance_valid(value):
			value.set_is_interactable(true)

func  _physics_process(_delta: float) -> void:
	_process_targets()
	
func _on_area_entered(area: Area2D) -> void:
	if not _filter(area):
		return
	_targets.append(area)

func _on_area_exited(area: Area2D) -> void:
	if not _filter(area):
		return
	_targets.erase(area)

func interact() -> String:
	if is_instance_valid(_interactable_target):
		return _interactable_target.interact()
	return "NO INTERACTION"
	
func _filter(area: Area2D) -> bool:
	if area is not InteractableComponent:
		return false
	if not _can_interact_with_tags.has((area as InteractableComponent).interaction_tag):
		return false
	return true

func _process_targets() -> void:
	_can_interact = not _targets.is_empty()
	_interactable_target = _closest_target()

func _closest_target() -> InteractableComponent:
	return _targets.reduce(
		func(prev: InteractableComponent, curr: InteractableComponent) -> InteractableComponent: 
			return curr if global_position.distance_squared_to(curr.global_position) < global_position.distance_squared_to(prev.global_position) else prev
	)
