extends VBoxContainer

const HP_DEFAULT = 2
const HP_HIGH = 5

var max_hitpoints: int = HP_DEFAULT
var cur_hitpoints: int;
var cur_mask: String = "Default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_hitpoints = max_hitpoints

func hit():
	print("hit")
	cur_hitpoints -= 1
	if cur_hitpoints == 1:
		cur_mask = "Disco"
		updateMask()
	updateHitpoints()

func changeMask(mask: String) -> void:
	cur_mask = mask
	if cur_mask in ['Smiley']:
		max_hitpoints = HP_HIGH
		cur_hitpoints = HP_HIGH
	else:
		max_hitpoints = HP_DEFAULT
		cur_hitpoints = HP_DEFAULT
	updateMask()
	updateHitpoints()

func updateMask():
	for mask in $SmileyPanel.get_children():
		mask.visible = false
	$SmileyPanel.find_child(cur_mask, false).visible = true

func updateHitpoints():
	$TextPanel/Label.text = "Life {0}/{1}".format([cur_hitpoints, max_hitpoints])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
