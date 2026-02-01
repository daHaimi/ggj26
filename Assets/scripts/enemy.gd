extends CharacterBody3D

@export var LIFE = 3
@export var SPEED = 3.0
@export var DAMPING = 15

signal hit_player

enum States {IDLE, ROAMING, SEARCHING, AGGRO, DEAD, ATTACK}

@export var footsteps_01: AudioStream
@export var footsteps_02: AudioStream
@export var footsteps_03: AudioStream
@onready var footsteps = [footsteps_01, footsteps_02, footsteps_03]

@export var voiceline_search: AudioStream
@export var voiceline_search_02: AudioStream
@export var voiceline_aggro: AudioStream
@export var voiceline_aggro_02: AudioStream
@export var voiceline_getting_hit: AudioStream
@export var voiceline_death: AudioStream

var state := States.IDLE
@onready var player = get_tree().get_nodes_in_group("player")[0]

@onready var rotation_axis = $RotationAxis
@onready var sight_cone = $RotationAxis/Sight
@onready var sight_raycast = $RayCast3D
@onready var aorange = $character/model/InRangeArea
@onready var aoa = $character/model/metarig/Skeleton3D/Hand/AttackArea
@onready var animation_player = $AnimationPlayer
@onready var char_animation: AnimationPlayer = $character/model/AnimationPlayer
@onready var enemy_type: String = $character.character_type

@onready var audio_effect = $AudioEffect
@onready var audio_voice = $AudioVoice

func _ready() -> void:
	char_animation.animation_finished.connect(_on_char_anim_finished)

func scan_for_player():
	var bodies: Array = sight_cone.get_overlapping_bodies()
	if bodies.size() > 0:
		sight_raycast.target_position = to_local(player.global_position)
		sight_raycast.force_raycast_update()
		var raycast_result = sight_raycast.get_collider()
		if raycast_result == player:
			if state not in [States.AGGRO, States.ATTACK]:
				char_animation.play("running")
				enter_aggro()
		else:
			match state:
				States.IDLE:
					pass
				States.SEARCHING:
					pass
				States.AGGRO:
					char_animation.play("idle")
					enter_searching()

	# Player not in sight cone
	else:	
		match state:
			States.IDLE:
				pass
			States.SEARCHING:
				pass
			States.AGGRO:
				char_animation.play("idle")
				enter_searching()
			#States.ATTACK:
				#char_animation.play("idle")
				#enter_searching()

func enter_aggro():
	if voiceline_aggro:
		if enemy_type == "Redneck":
			var voicelines = [voiceline_aggro, voiceline_aggro_02]
			audio_voice.stream = voicelines.pick_random()
		else:
			audio_voice.stream = voiceline_aggro
		audio_voice.play()
	state = States.AGGRO
	animation_player.stop()
	rotation_axis.rotation = Vector3.ZERO

func enter_searching():
	if voiceline_search:
		if enemy_type == "Agent":
			var voicelines = [voiceline_search, voiceline_search_02]
			audio_voice.stream = voicelines.pick_random()
		else:
			audio_voice.stream = voiceline_search
		audio_voice.play()
	state = States.SEARCHING
	velocity = Vector3.ZERO
	animation_player.stop()
	animation_player.play("enemy_searching")

func enter_idle():
	state = States.IDLE
	velocity = Vector3.ZERO
	animation_player.stop()	
	char_animation.play("idle")

func enter_attack():
	state = States.ATTACK
	velocity = Vector3.ZERO
	animation_player.stop()	
	$character.attack()
	
func enter_dead():
	state = States.DEAD
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	if voiceline_death:
		audio_voice.stream = voiceline_death
		audio_voice.play()
	# play death animation
	char_animation.play("dying")

func hit(damage: int):
	LIFE = clamp(LIFE - damage, 0, LIFE)
	if voiceline_getting_hit:
		audio_voice.stream = voiceline_getting_hit
		audio_voice.play()
	if LIFE == 0:
		enter_dead()
	else: 
		look_at(player.position)

func play_footsteps():
	if audio_effect and not audio_effect.playing:
		audio_effect.stream = footsteps.pick_random()
		audio_effect.play()

func move_to_player(new_position: Vector3, stop_distance: float, delta):
	var speed_used
	match state:
		States.IDLE:
			speed_used = SPEED
		States.ROAMING:
			speed_used = SPEED
		States.SEARCHING:
			speed_used = SPEED
		States.AGGRO:
			speed_used = SPEED
	
	#print(speed_used)
	if player:
		var direction: Vector3 = (player.global_position - global_position)
		direction.y = 0
		direction = direction.normalized()
		velocity.x = direction.x * speed_used
		velocity.z = direction.z * speed_used

		look_at(player.position)
		
	else:
		velocity.x = move_toward(velocity.x, 0, DAMPING * delta)
		velocity.z = move_toward(velocity.z, 0, DAMPING * delta)


func _physics_process(delta: float) -> void:
	if state == States.DEAD:
		return
	scan_for_player()
	match state:
		States.IDLE:
			pass
		States.ROAMING:
			pass
		States.SEARCHING:
			pass
			print("searching")
			#searching(delta)
		States.AGGRO:
			move_to_player(Vector3.ZERO, 0, delta)
			detect_attack()
		States.ATTACK:
			look_at(player.position)
			deal_damage()
	if velocity.length() > 0: 
		play_footsteps()
	move_and_slide()

func _on_char_anim_finished(anim_name: String):
	if (
		enemy_type == "Redneck" and anim_name == "hook-punch"
	) or (
		enemy_type == "Hitman" and anim_name == "pistol"
	):
		enter_searching()

func deal_damage():
	var collisions: Array = aoa.get_overlapping_bodies()
	if collisions.size() > 0:
		hit_player.emit()
		state = States.IDLE

func detect_attack():
	var collisions: Array = aorange.get_overlapping_bodies()
	if collisions.size() > 0:
		enter_attack()
