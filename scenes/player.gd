extends CharacterBody3D

@export var PlayerCamera : GimbalCamera
@export var left_weapon : Node
@export var right_weapon : Node
var weapon_idx = 0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var can_dash = true
var last_dash_was_surface = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")*1.2


func _physics_process(delta):
	# Add the gravity.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	if not (is_on_floor()):
		velocity.y -= gravity * delta
	if is_on_wall() and input_dir.length()>0.5:
		velocity.y = max(velocity.y,0.0)
	# Handle Jump.
#	self.
#	if can_dash and last_dash_was_surface: can_dash = true
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var rotation_vector = event.relative/Globals.Settings.MouseSensitivity
		PlayerCamera.gimbal_rotation_degrees.y += -rotation_vector.y
		rotation_degrees.y += -rotation_vector.x
	if event.is_action_pressed("fire"):
		var weapon = [left_weapon,right_weapon][weapon_idx]
		weapon.fire()
		weapon_idx = (weapon_idx+1)%2
	if event.is_action_pressed("dash") and can_dash:
		velocity += PlayerCamera.camera_global_transform.basis*Vector3(0,0,-1)*SPEED*10.0
#		can_dash = false
		last_dash_was_surface = is_on_floor() or is_on_wall()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
