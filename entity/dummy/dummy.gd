extends StaticBody2D

@onready var health_component: HealthComponent = %HealthComponent

func _process(delta: float) -> void:
	#todo крутой тестовый хелзбар + как-то респавнить
	DebugDraw2D.set_text("dummy health", health_component.get_current_value())


func _on_health_component_dead() -> void:
	queue_free()
