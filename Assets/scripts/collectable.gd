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
	if mask_name == "Tony":
		$Sprite3D.texture = sprite_tony
	elif mask_name == "Jigsaw":
		$Sprite3D.texture = sprite_jigsaw
	elif mask_name == "Mask":
		$Sprite3D.texture = sprite_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(transform.basis.y.normalized(), rotate_speed * delta)
	pass
