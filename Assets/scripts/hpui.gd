extends Panel

@onready var hp2 = $Hp2
@onready var hp5 = $Hp5

@onready var hp2Segments = hp2.find_children("Hp2")
@onready var hp5Segments = hp5.find_children("Hp5")

var max_before = 2;

func update(max: int, val: int):
	if max != max_before:
		if max == 5:
			hp2.hide()
			hp5.show()
		else:
			hp2.show()
			hp5.hide()
		max_before = max
	var segments = hp2Segments if max == 2 else hp5Segments
	var i = 0
	for seg in segments:
		if i < val: seg.show()
		else: seg.hide()
		i += 1
