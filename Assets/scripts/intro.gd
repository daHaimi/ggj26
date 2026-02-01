extends CanvasLayer

func _ready():
	ResourceLoader.load_threaded_request("res://scenes/level.tscn")

func _input(event):
	if event.is_action("ui_cancel") or event.is_action("attack"):
		get_tree().change_scene_to_node(ResourceLoader.load_threaded_get("res://scenes/level.tscn").instantiate())
