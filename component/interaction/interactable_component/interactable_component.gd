@tool
class_name InteractableComponent
extends Area2D

signal interacted
signal is_interactable_changed(is_interactable: bool)


func interact() -> void:
	interacted.emit()
	
func set_is_interactable(new_is_interactable: bool) -> void:
	is_interactable_changed.emit(new_is_interactable)
