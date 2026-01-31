extends Node3D

@export var character_type: String

@onready var animator: AnimationPlayer = $model/AnimationPlayer

var attack_map: Dictionary = {
	"Redneck" = "hook-punch",
	"Hitman" = "pistol"
}

func getAnimator() -> AnimationPlayer:
	return animator

func attack():
	animator.play(attack_map[character_type])
