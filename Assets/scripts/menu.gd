extends CanvasLayer

func _ready() -> void:
	BackgroundMusic.play_background_music()

func startGame():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
	
func showCredits():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
func quitGame():
	get_tree().quit()
