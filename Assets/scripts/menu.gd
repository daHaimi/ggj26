extends CanvasLayer


func startGame():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
	
func showCredits():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
func quitGame():
	get_tree().quit()
