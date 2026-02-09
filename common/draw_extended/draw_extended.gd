class_name DrawExtended
#todo всратое название класса может передумать роль? CanvasItem?

static func draw_polyline_colors_with_circles(
	canvas_item: CanvasItem,
	points: PackedVector2Array,
	radius: float,
	width: float = -1.0,
	antialiased: bool = false,
	color_from: Color = Color.GREEN,
	color_to: Color = Color.DARK_RED
) -> void:
	var colors: Array[Color]
	for i in range(0, points.size() -1):
		colors.append(color_from.lerp(color_to, float(i) / (points.size() - 1) ))
		canvas_item.draw_line(points[i], points[i+1], colors[i], width, antialiased)
		if (i != 0):
			canvas_item.draw_circle(points[i], radius, colors[i-1])

static func draw_arrow(node: Node2D, origin: Vector2, target: Vector2, color: Color, width: float = -1, filled: bool = false, head_length: float = 2.5, head_angle: float = PI / 4.0) -> void:
	target -= origin * 2
	var head: Vector2 = -target.normalized() * head_length
	var end = -target.normalized() * head_length / 2 + target + origin
	target += origin
	var head_right = target + head.rotated(head_angle)
	var head_left = target + head.rotated(-head_angle)

	if filled:
		node.draw_line(origin, end, color, width)
		node.draw_colored_polygon([head_right, target, head_left], color)
	else:
		node.draw_line(origin, target , color, width)
		node.draw_polyline([head_right, target , head_left], color, width)
