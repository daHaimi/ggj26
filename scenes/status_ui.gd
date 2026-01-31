extends VBoxContainer

const HP_DEFAULT = 2
const HP_HIGH = 5

@onready var glowShader: Shader = preload("res://Assets/Shaders/glow.gdshader")
var max_hitpoints: int = HP_DEFAULT
var cur_hitpoints: int;
var cur_mask: String = "Default"
var glow: ShaderMaterial

func _ready() -> void:
	glow = ShaderMaterial.new()
	glow.shader = glowShader
	glow.set_shader_parameter("active", true)
	cur_hitpoints = max_hitpoints

func detected(det: bool):
	# Todo
	pass
		
func hit():
	print("hit")
	cur_hitpoints -= 1
	if cur_hitpoints == 1:
		updateMask()
	updateHitpoints()

func changeMask(mask: String) -> void:
	cur_mask = mask
	if cur_mask in ['Tony']:
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
	var avatar: AnimatedSprite2D = $SmileyPanel.find_child(cur_mask)
	if cur_hitpoints == 1:
		avatar.material = glow
	else:
		avatar.material = null
	$TextPanel/Label.text = "Life {0}/{1}".format([cur_hitpoints, max_hitpoints])
