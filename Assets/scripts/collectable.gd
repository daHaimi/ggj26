extends Area3D

@export var rotate_speed: float = 2.0
@export var mask_name: String
@export var sprite_tony: Texture
@export var sprite_jigsaw: Texture
@export var sprite_mask: Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate(transform.basis.z.normalized(), deg_to_rad(45))
	rotate(transform.basis.x.normalized(), deg_to_rad(-45))
	var mat = StandardMaterial3D.new()
	if mask_name == "Tony":
		mat.albedo_texture = sprite_tony
	elif mask_name == "Jigsaw":
		mat.albedo_texture = sprite_jigsaw
	elif mask_name == "Mask":
		mat.albedo_texture = sprite_mask
	mat.uv1_scale = Vector3(3.0, 2.0, 2.0)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	$MeshInstance3D.set_material_override(mat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(transform.basis.y.normalized(), rotate_speed * delta)
	pass
