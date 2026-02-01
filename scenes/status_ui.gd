extends VBoxContainer

const HP_DEFAULT = 2
const HP_HIGH = 5
const STRENGTH_DEFAULT = 1
const STRENGTH_HIGH = 1

signal player_hit

@onready var glowShader: Shader = preload("res://Assets/Shaders/glow.gdshader")
@onready var dashBar: Sprite2D = $Panel/DashBar
@onready var smileyPanel: Panel = $Panel/SmileyPanel
@onready var hpPanel: Panel = $Panel/HpPanel
var max_hitpoints: int = HP_DEFAULT
var cur_hitpoints: int;
var cur_strength: int = STRENGTH_DEFAULT;
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


func can_attack() -> bool:
	return cur_mask != "Default"

func is_fast() -> bool:
	return cur_mask == "Tony"

func hit():
	print("hit")
	cur_hitpoints = clampi(cur_hitpoints - 1, 0, max_hitpoints)
	if cur_hitpoints == 1:
		updateMask()
	updateHitpoints()
	player_hit.emit(cur_hitpoints)

func changeMask(mask: String) -> void:
	cur_mask = mask
	if cur_mask in ['Jigsaw']:
		max_hitpoints = HP_HIGH
		cur_hitpoints = HP_HIGH
	else:
		max_hitpoints = HP_DEFAULT
		cur_hitpoints = HP_DEFAULT
	updateMask()
	updateHitpoints()

func updateMask():
	for mask in smileyPanel.get_children():
		mask.visible = false
	smileyPanel.find_child(cur_mask, false).visible = true

func updateHitpoints():
	var avatar: AnimatedSprite2D = smileyPanel.find_child(cur_mask)
	if cur_hitpoints == 1:
		avatar.material = glow
	else:
		avatar.material = null
	hpPanel.update(max_hitpoints, cur_hitpoints)


func _on_player_mask_collected(mask):
	pass # Replace with function body.
