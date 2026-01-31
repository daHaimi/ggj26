extends Node3D

@onready var animator: AnimationPlayer = $model/AnimationPlayer

func getAnimator() -> AnimationPlayer:
	return animator
