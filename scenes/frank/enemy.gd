extends CharacterBody3D

@export var LIFE = 3
@export var SPEED = 3.0
@export var DAMPING = 15

enum States {IDLE, ROAMING, SEARCHING, AGGRO}
var state := States.IDLE

var player = null

@onready var rotation_axis = $RotationAxis
@onready var sight_cone = $RotationAxis/Sight
@onready var sight_raycast = $RayCast3D
@onready var animation_player = $AnimationPlayer
func scan_for_player():
	var bodies: Array = sight_cone.get_overlapping_bodies()
	if bodies.size() > 0:
		print("player in cone")
		player = bodies[0]
		
		sight_raycast.target_position = to_local(player.global_position)
		print(player.global_position)
		print(sight_raycast.target_position)
		sight_raycast.force_raycast_update()
		var raycast_result = sight_raycast.get_collider()
		# print(raycast_result)
		if raycast_result == player:
			if state != States.AGGRO:
				enter_aggro()

	else:	
		match state:
			States.IDLE:
				pass
			States.SEARCHING:
				pass
			States.AGGRO:
				enter_searching()

func enter_aggro():
	state = States.AGGRO
	animation_player.stop()
	rotation_axis.rotation = Vector3.ZERO

func enter_searching():
	state = States.SEARCHING
	animation_player.stop()
	animation_player.play("enemy_searching")

func enter_idle():
	state = States.IDLE
	velocity = Vector3.ZERO
	animation_player.stop()	


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

	move_and_slide()
