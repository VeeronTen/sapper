class_name InteractableComponent
extends Area2D

@export var interaction_tag: String = ""

signal interacted
signal is_interactable_changed(is_interactable: bool)


func interact() -> String:
	interacted.emit()
	return interaction_tag
	
func set_is_interactable(new_is_interactable: bool) -> void:
	is_interactable_changed.emit(new_is_interactable)
