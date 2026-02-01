extends ColorRect

const MAX_ALPHA = .6

func notify_hit(_ignore):
	color = Color(Color.RED, MAX_ALPHA)
	print(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(color)
	color.a = clampf(color.a - delta * 1.5, 0.0, MAX_ALPHA)
