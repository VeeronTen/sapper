extends StaticBody2D

#todo rebake nav


func _on_interactable_component_interacted() -> void:
	prints("bomb INTERACT")

func _on_interactable_component_is_interactable_changed(is_interactable: bool) -> void:
	prints("bomb is_interactable", is_interactable)
