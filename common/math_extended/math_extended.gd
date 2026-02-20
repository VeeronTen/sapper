class_name MathExtended

static func is_in_range(value: Variant, min_border: Variant, max_border: Variant) -> bool:
	var result: bool = true
	if min_border:
		result = result and value >= min_border
	if max_border:
		result = result and value <= max_border
	return result

static func remap_by_deadzone(value: float, start: float, stop: float, deadzone: float) -> float:
	var abs_val: float = abs(value)
	if abs_val <= deadzone:
		return start
	var mapped_val: float = remap(abs_val, deadzone, stop, start, stop)
	return mapped_val * sign(value)
