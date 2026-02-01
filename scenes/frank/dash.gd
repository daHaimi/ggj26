extends Node3D

@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var stats = get_tree().get_nodes_in_group("globals")[0]

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
	dash_cooldown_timer.timeout.connect(func(): dash_ready = true)
	dash_timer.timeout.connect(func(): dashing = false)

func _process(delta: float) -> void:
	if dashing:
		stats.dashBar.update(dash_timer.time_left / dash_timer.wait_time)
	elif !dash_ready && dash_cooldown_timer.time_left > 0: # Cooling down
		stats.dashBar.update(1 - (dash_cooldown_timer.time_left / (dash_cooldown_timer.wait_time - dash_timer.wait_time)))
		
