extends Node3D

@onready var animator_hitman: AnimationPlayer = $hitman/model/AnimationPlayer
@onready var animator_player: AnimationPlayer = $PlayerChar/model/AnimationPlayer
@onready var animator_redneck: AnimationPlayer = $Redneck/model/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animator_hitman.play("hiphop-dancing")
	animator_hitman.get_animation("hiphop-dancing").loop_mode = Animation.LOOP_LINEAR
	animator_player.play("hiphop-dancing")
	animator_redneck.play("hiphop-dancing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
