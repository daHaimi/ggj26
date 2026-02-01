extends MeshInstance3D

@export var rotate_speed: float = 2.0

@onready var masks = {
	"None" = preload("res://Assets/img/transpixel.png"),
	"Tony" = preload("res://Assets/img/sprite_tony.png"),
	"Jigsaw" = preload("res://Assets/img/sprite_jigsaw.png"),
	"Mask" = preload("res://Assets/img/sprite_mask.png")
} 

func _ready() -> void:
	activate("None")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(transform.basis.y.normalized(), rotate_speed * delta)


func activate(name: String):
	material_override.albedo_texture = masks.get(name)
