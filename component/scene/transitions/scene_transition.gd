@abstract
class_name SceneTransition
extends Node

enum TransitionDirection { IN, OUT }

@abstract
func play_till_end(direction: TransitionDirection) -> Signal
