class_name CurveExtended

static func set_strict_bounds(curve: Curve, domain_min: Variant, domain_max: Variant, value_min: Variant, value_max: Variant, tag: String = "", require_points_at_borders: bool = false) -> void:
	assert(domain_min != domain_max, "%s curve have no sense: no domain spread" % tag)
	assert(value_min != value_max, "%s curve have no sense: no value spread" % tag)
	if domain_min is float: curve.min_domain = domain_min
	if domain_max is float: curve.max_domain = domain_max
	if value_min is float: curve.min_value = value_min
	if value_max is float: curve.max_value = value_max
	curve.domain_changed.connect(func() -> void: 
		curve.set_block_signals(true)
		if domain_min is float: curve.min_domain = domain_min
		if domain_max is float: curve.max_domain = domain_max
		curve.set_block_signals(false)
	)
	curve.range_changed.connect(func() -> void: 
		curve.set_block_signals(true)
		if value_min is float: curve.min_value = value_min
		if value_max is float: curve.max_value = value_max
		curve.set_block_signals(false)
	)
	assert_curve_within_its_own_bounds(curve, domain_min, domain_max, value_min, value_max, tag)

static func assert_curve_within_its_own_bounds(curve: Curve, domain_min: Variant, domain_max: Variant, value_min: Variant, value_max: Variant, tag: String = "", require_points_at_borders: bool = false) -> void:
	var have_point_with_min_y: bool = false
	var have_point_with_max_y: bool = false
	for i: int in range(curve.point_count):
		var p: Vector2 = curve.get_point_position(i)
		var x_ok: bool = MathExtended.is_in_range(p.x, domain_min, domain_max)
		var y_ok: bool = MathExtended.is_in_range(p.y, value_min, value_max)
		if p.y == value_max:
			have_point_with_max_y = true
		if p.y == value_min:
			have_point_with_min_y = true
		assert(x_ok, "%s x is out of bounds: %s [%s, %s]" % [tag, p.x, domain_min, domain_max])
		assert(y_ok, "%s y is out of bounds: %s [%s, %s]" % [tag, p.y, value_min, value_max])
	if not Engine.is_editor_hint() and require_points_at_borders:
		assert(have_point_with_min_y, "%s no point at min value bound: %s" % [tag, value_min])
		assert(have_point_with_max_y, "%s no point at max value bound: %s" % [tag, value_max])
