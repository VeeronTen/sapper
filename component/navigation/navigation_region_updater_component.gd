@tool
extends Node2D
class_name NavigationRegionUpdaterComponent

@export var max_distance_to_update: float = 20:
	set(value):
		max_distance_to_update = value
		queue_redraw()

var _root: Window

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_root = get_tree().root
	
func update() -> void:
	var regions: Array[NavigationRegion2D] = []
	regions.assign(_root.find_children("*", "NavigationRegion2D", true, false))
	for r: NavigationRegion2D in regions:
		if _need_to_rebake(r):
			r.bake_navigation_polygon()

func _need_to_rebake(region: NavigationRegion2D) -> bool:
	var region_rid: RID = region.get_region_rid()
	var closest_point: Vector2 = NavigationServer2D.region_get_closest_point(region_rid, global_position)
	var distance: float = global_position.distance_to(closest_point)
	return distance <= max_distance_to_update

func _draw() -> void:
	if not NavigationServer2D.get_debug_enabled():
		return
	draw_circle(Vector2.ZERO, max_distance_to_update, Color(1, 1, 1, 0.3))
