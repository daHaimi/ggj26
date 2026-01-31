extends CharacterBody3D


const SPEED = 5.0
const DAMPING = 15.0
const DASH_SPEED = 15
const DASH_MAX_TIME = 3.0

@onready var dash_component = $Dash
#@onready var dash_timer = $DashTimer
#@onready var dash_timer = $DashCooldownTimer
# hide disables collider layer 2
# 

func dash():
	if dash_component.dash_ready:
		dash_component.dash()
		

func hide_from_enemy():
	pass

#const JUMP_VELOCITY = 4.5
var isometric_angle = deg_to_rad(45)

### Picking up ###
func _body_entered(body):
	print(body)
	if is_in_group("lava"):
		pass
		#character_body.translation = Vector3(1, 1, 1)
		# Set the position of the node to (x, y, z)`[enter image description here][1]

func _physics_process(delta: float) -> void:
	
	### MOVEMENT ###
	# Add the gravity. Important for physics bugging
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3(0,1,0), isometric_angle)
	
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

	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		print("Collided with: ", body.name)
