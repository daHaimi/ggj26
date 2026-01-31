extends CharacterBody3D

const SPEED = 5.0
const DAMPING = 25.0
const DASH_SPEED = 15
const DASH_MAX_TIME = 3.0

signal mask_collected(mask: String)
signal hit

@onready var dash_component = $Dash
#@onready var dash_timer = $DashTimer
#@onready var dash_timer = $DashCooldownTimer
# hide disables collider layer 2

var direction: Vector3

func dash():
	if dash_component.dash_ready:
		dash_component.dash()
		

func hide_from_enemy():
	pass

#const JUMP_VELOCITY = 4.5
var isometric_angle = deg_to_rad(45)


func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var anim: AnimationPlayer = $PlayerChar/model/AnimationPlayer
	anim.playback_default_blend_time = 1.5
	if input_dir != Vector2.ZERO:
		anim.play("running")
		direction = direction.rotated(Vector3(0,1,0), -isometric_angle)
		var modelTarget = direction.rotated(Vector3(0,1,0), deg_to_rad(-90))
		var target_angle = atan2(modelTarget.x, modelTarget.z)
		# Lerp into direction
		$PlayerChar.rotation.y = lerp_angle($PlayerChar.rotation.y, target_angle, delta * 10)
	else:
		anim.play("idle")
	
	
	### Picking up ###
	for area: Area3D in $Pickup.get_overlapping_areas():
		if area.name == "Mask":
			mask_collected.emit("Tony")
		elif area.name == "Machete":
			hit.emit()
		else:
			print("Collected: ", area)
		area.queue_free()

func _physics_process(delta: float) -> void:
	
	### MOVEMENT ###
	# Add the gravity. Important for physics bugging
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY


	if Input.is_action_just_pressed("ui_accept"):
		dash()

	var speed_used = SPEED
	if dash_component.dashing:
		speed_used = DASH_SPEED

	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed_used
		velocity.z = direction.z * speed_used
	else:
		velocity.x = move_toward(velocity.x, 0, DAMPING * delta)
		velocity.z = move_toward(velocity.z, 0, DAMPING * delta)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody3D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 10.0)

	#move_and_slide()
