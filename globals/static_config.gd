extends Node

func _ready() -> void:
	_setup_debug_draw()
	_setup_damaging_ray_component_debug()
	
func _setup_debug_draw() -> void:
	DebugDraw2D.config.text_default_size = 25
	
func _setup_damaging_ray_component_debug() -> void:
	DamagingRayComponentDebug.draw_hit_rays = true
	DamagingRayComponentDebug.draw_hit_rays_time = 3.5
