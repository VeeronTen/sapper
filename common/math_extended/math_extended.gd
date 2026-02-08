class_name MathExtended

static func is_in_range(value: Variant, min_border: Variant, max_border: Variant) -> bool:
	var result: bool = true
	if min_border:
		result = result and value >= min_border
	if max_border:
		result = result and value <= max_border
	return result
