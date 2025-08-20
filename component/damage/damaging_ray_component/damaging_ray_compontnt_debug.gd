class_name DamagingRayComponentDebug
extends Node2D

static var draw_hit_rays: bool = true:
	set(value):
		draw_hit_rays = value and OS.is_debug_build
static var draw_hit_rays_time: float = 1.5

var _hit_rays: Array[Array] = []

func _draw() -> void:
	for hr in _hit_rays:
		var hit_points = hr.map(func(p: Vector2) -> Vector2: return to_local(p))
		DrawExtended.draw_polyline_colors_with_circles(self, hit_points, 3, 1.5)
			
func _process(delta: float) -> void:
	if not _hit_rays.is_empty(): queue_redraw()

func add_hit_ray(collisions: Array[Vector2], is_piercing: bool, target_position: Vector2): 
	var new_hit_ray: Array[Vector2] = []
	new_hit_ray.append(global_position)
	for c in collisions:
		new_hit_ray.append(c)
	if is_piercing or collisions.is_empty():
		new_hit_ray.append(target_position)
	_hit_rays.append(new_hit_ray)
	queue_redraw()
	await get_tree().create_timer(draw_hit_rays_time).timeout
	_hit_rays.erase(new_hit_ray)
	queue_redraw()
