class_name InteractingComponent
extends Area2D

@export var _can_interact_with_tags: Array[String]

signal can_interact_changed(can_interact: bool)

var _interactable_target: InteractableComponent:
	set(value):
		if value == _interactable_target:
			return
		if is_instance_valid(_interactable_target):
			_interactable_target.set_is_interactable(false)
		_interactable_target = value
		if is_instance_valid(value):
			value.set_is_interactable(true)
		
var _interactables_nearby: int = 0:
	set(value):
		if value == 0 and _interactables_nearby != 0:
			can_interact_changed.emit(false)
		if value != 0 and _interactables_nearby == 0:
			can_interact_changed.emit(true)
		_interactables_nearby = value

func _on_area_entered(area: Area2D) -> void:
	if area is not InteractableComponent:
		return
	if not _can_interact_with_tags.has((area as InteractableComponent).interaction_tag):
		return
	_interactable_target = area
	_interactables_nearby += 1

func _on_area_exited(area: Area2D) -> void:
	if area is not InteractableComponent:
		return
	if not _can_interact_with_tags.has((area as InteractableComponent).interaction_tag):
		return
	if area == _interactable_target:
		_interactable_target = null
	_interactables_nearby -= 1

func interact() -> String:
	if is_instance_valid(_interactable_target):
		return _interactable_target.interact()
	return "NO INTERACTION"
