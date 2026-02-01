extends CharacterBody3D

const SPEED = 5.0
const DAMPING = 25.0
const DASH_SPEED = 15
const DASH_MAX_TIME = 3.0

signal mask_collected(mask: String)
signal hit

@export var footsteps_01: AudioStream
@export var footsteps_02: AudioStream
@export var footsteps_03: AudioStream
@onready var footsteps = [footsteps_01, footsteps_02, footsteps_03]

@export var sound_hitting: AudioStream
@export var voiceline_getting_hit: AudioStream
@export var voiceline_death: AudioStream

@export var sound_tiger_mask: AudioStream
@export var sound_jigsaw_mask: AudioStream
@export var sound_the_mask: AudioStream

@onready var dash_component = $Dash
@onready var animator: AnimationPlayer = $PlayerChar/model/AnimationPlayer
@onready var face: MeshInstance3D = $PlayerChar/model/metarig/Skeleton3D/Head/FaceMask
@onready var punch: Area3D = $PlayerChar/PunchArea
@onready var stats = get_tree().get_nodes_in_group("globals")[0]

@onready var audio_effect = $AudioEffect
@onready var audio_voice = $AudioVoice

#@onready var dash_timer = $DashTimer
#@onready var dash_timer = $DashCooldownTimer
# hide disables collider layer 2

#const JUMP_VELOCITY = 4.5
var isometric_angle = deg_to_rad(45)
var direction: Vector3
var attacking: bool = false

func dash():
	if dash_component.dash_ready:
		dash_component.dash()
		

func check_hit_enemy():
	var bodies: Array = punch.get_overlapping_bodies()
	for body in bodies:
		body.hit(stats.cur_strength)

func play_footsteps():
	if audio_effect and not audio_effect.playing:
		audio_effect.stream = footsteps.pick_random()
		audio_effect.play()

func _on_player_got_hit(cur_health: int):
	if cur_health <= 0:
		die()
	else:
		audio_voice.stream = voiceline_getting_hit
		audio_voice.play()

func die():
	audio_voice.stream = voiceline_death
	audio_voice.play()

func _ready() -> void:
	animator.playback_default_blend_time = 1.5
	animator.animation_finished.connect(_on_char_anim_finished)

func _on_char_anim_finished(name: String):
	if name == "slash":
		check_hit_enemy()
		animator.play("idle")
		attacking = false

func play_mask_pickup_sound(mask_name: String):
	print(mask_name)
	match mask_name:
		"Tony":
			audio_voice.stream = sound_tiger_mask
		"Jigsaw":
			audio_voice.stream = sound_jigsaw_mask
		"Mask":
			audio_voice.stream = sound_the_mask
	audio_voice.play()
	
func _process(delta: float) -> void:
		
	if Input.is_action_just_pressed("attack"):
		if !attacking:
			attacking = true
			animator.play("slash")
	elif !attacking:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if input_dir != Vector2.ZERO:
			animator.play("running")
			direction = direction.rotated(Vector3(0,1,0), -isometric_angle)
			var modelTarget = direction.rotated(Vector3(0,1,0), deg_to_rad(-90))
			var target_angle = atan2(modelTarget.x, modelTarget.z)
			# Lerp into direction
			$PlayerChar.rotation.y = lerp_angle($PlayerChar.rotation.y, target_angle, delta * 10)
		else:
			animator.play("idle")
	
	
	### Picking up ###
	for area: Area3D in $Pickup.get_overlapping_areas():
		if area.name.begins_with("Mask_"):
			mask_collected.emit(area.mask_name)
			face.activate(area.mask_name)
			play_mask_pickup_sound(area.mask_name)
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
	if attacking:
		speed_used = 0
	elif dash_component.dashing:
		animator.set_speed_scale(DASH_SPEED / SPEED)
		speed_used = DASH_SPEED
	else: animator.set_speed_scale(1.0)

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
	
	if velocity.length() > 0: 
		play_footsteps()


func _on_stats_player_hit(cur_health) -> void:
	print(cur_health)
	if cur_health <= 0:
		die()
	else:
		audio_voice.stream = voiceline_getting_hit
		audio_voice.play()
