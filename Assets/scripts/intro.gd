extends CanvasLayer

var level: Resource

func _input(event):
	if event.is_action("ui_cancel") or event.is_action("attack"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
