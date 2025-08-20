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
