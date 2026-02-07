class_name CurveExtended

static func set_strict_bounds(curve: Curve, domain: Vector2, value: Vector2, tag: String = "") -> void:
	assert(domain.x != domain.y, "%s curve have no sense: no domain spread" % tag)
	assert(value.x != value.y, "%s curve have no sense: no value spread" % tag)
	curve.min_domain = domain.x
	curve.max_domain = domain.y
	curve.min_value = value.x
	curve.max_value = value.y
	curve.domain_changed.connect(func() -> void: 
		curve.set_block_signals(true)
		curve.min_domain = domain.x
		curve.max_domain = domain.y
		curve.set_block_signals(false)
	)
	curve.range_changed.connect(func() -> void: 
		curve.set_block_signals(true)
		curve.min_value = value.x
		curve.max_value = value.y
		curve.set_block_signals(false)
	)
	assert_curve_within_its_own_bounds(curve, domain, value, tag)

static func assert_curve_within_its_own_bounds(curve: Curve, domain: Vector2, value: Vector2, tag: String = "") -> void:
	var have_point_with_min_y: bool = false
	var have_point_with_max_y: bool = false
	for i: int in range(curve.point_count):
		var p: Vector2 = curve.get_point_position(i)
		var x_ok: bool = MathExtended.is_in_range(p.x, domain.x, domain.y)
		var y_ok: bool = MathExtended.is_in_range(p.y, value.x, value.y)
		if p.y == value.y:
			have_point_with_max_y = true
		if p.y == value.x:
			have_point_with_min_y = true
		assert(x_ok, "%s x is out of bounds: %s [%s, %s]" % [tag, p.x, domain.x, domain.y])
		assert(y_ok, "%s y is out of bounds: %s [%s, %s]" % [tag, p.y, value.x, value.y])
	if not Engine.is_editor_hint():
		assert(have_point_with_min_y, "%s no point at min value bound: %s" % [tag, value.x])
		assert(have_point_with_max_y, "%s no point at max value bound: %s" % [tag, value.y])
