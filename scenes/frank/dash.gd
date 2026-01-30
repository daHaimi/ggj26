extends Node3D

@onready var dash_timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

var dash_ready = true
var dashing = false

# Called when the node enters the scene tree for the first time.
func dash():
	if dash_ready:
		dash_timer.start()
		dash_cooldown_timer.start()
		dashing = true
		dash_ready = false

func _ready() -> void:
	pass # Replace with function body.
	dash_cooldown_timer.timeout.connect(func(): dash_ready = true)
	dash_timer.timeout.connect(func(): dashing = false)
