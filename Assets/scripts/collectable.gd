extends Area3D

@export var float_speed: float = 1.0
@export var float_limit: float = 1.0
@export var rotate_speed: float = 2.0

var floatStart: float;
var floatProgress: float;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floatStart = position.y
	# Random start
	floatProgress = randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	floatProgress += delta
	position.y = floatStart + (sin(floatProgress) + .5) * float_limit;
	rotate_y(rotate_speed * delta)
