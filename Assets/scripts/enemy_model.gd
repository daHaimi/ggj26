extends Node3D

@export var character_type: String

@onready var animator: AnimationPlayer = $model/AnimationPlayer
@onready var aoe: CollisionShape3D = $model/metarig/Skeleton3D/Hand/AttackArea/CollisionShape3D

var attack_map: Dictionary = {
	"Redneck" = "hook-punch",
	"Hitman" = "pistol"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aoe.disabled = true
	
func getAnimator() -> AnimationPlayer:
	return animator

func attack():
	animator.play(attack_map[character_type])

func anim_attack(active: bool):
	aoe.disabled = !active
