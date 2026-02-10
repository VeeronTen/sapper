extends SceneTransition

@onready var _color_rect: ColorRect = %ColorRect

func play_till_end(direction: TransitionDirection) -> Signal:
	var initial_alpha: float
	var target_alpha: float
	match direction:
		SceneTransition.TransitionDirection.IN:
			initial_alpha = 1.0
			target_alpha = 0.0
		SceneTransition.TransitionDirection.OUT:
			initial_alpha = 0.0
			target_alpha = 1.0
		_:
			assert(false)
	_color_rect.color.a = initial_alpha
	return create_tween().tween_property(_color_rect, "color:a", target_alpha, 0.8).finished
