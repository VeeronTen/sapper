extends SceneTransition


func play_till_end(direction: TransitionDirection) -> Signal:
	return get_tree().create_timer(1).timeout
