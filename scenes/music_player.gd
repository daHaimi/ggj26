extends Node
class_name MusicPlayer

@export var calm_track: AudioStream
@export var fast_track: AudioStream

@onready var audio_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	$AudioPlayerCalm.finished.connect($AudioPlayerCalm.play)
	$AudioPlayerFast.finished.connect($AudioPlayerFast.play)
	$AudioPlayerFast.volume_db = -80

func play_background_music():
	if not $AudioPlayerCalm.playing:
		$AudioPlayerCalm.play()
	if not $AudioPlayerFast.playing:
		$AudioPlayerFast.play()
	
func play_calm():
	animation_player.play("fast_to_calm")
	
	
func play_fast():
	animation_player.play("calm_to_fast")

# Called when the node enters the scene tree for the first time.
func get_instance():
	return self

# DEBUG STUFF!!!
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_J):
		play_calm()
	elif Input.is_key_pressed(KEY_K):
		play_fast()
	elif Input.is_key_pressed(KEY_L):
		play_background_music()
