extends CharacterBody3D
class_name Player

#@export var test : bool = true
@export var PlayerCamera : Node
@export var left_weapon : Node
@export var right_weapon : Node
@export var kinetic_acceleration : float = 1.0
@export var kinetic_deceleration : float = 5.0
@export var base_speed : float = 5.0
@export var dash_regen : float = 1.0
@export var dash_drain : float = 1.0
@export var score : int = 0:
	set(n_score):
		score = n_score
		if not is_inside_tree(): await ready
		$UI.score = score

@export var pause_screen : PackedScene = preload("res://scenes/UI/pause_menu.tscn")
var dashing : bool = false
var dash_amount : float = 1.0
var pre_dash_velocity : Vector3 = Vector3.ZERO
var weapon_idx = 0
var SPEED = 5.0
var JUMP_VELOCITY = 10.0
var can_dash = true
var last_dash_was_surface = false
var previous_position = Vector3.ZERO
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")*3


func _physics_process(delta):
	# Add the gravity.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var current_position = global_position
	var world_speed : Vector3 = abs(current_position-previous_position)/delta
	previous_position = current_position
	if world_speed.x**2.0+world_speed.z**2.0 > 4.0:
		SPEED += kinetic_acceleration*delta
	else:
		SPEED = lerpf(SPEED, base_speed, kinetic_deceleration*delta)
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
#	print(direction)
#	print(input_dir)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if dashing:
		var new_velocity = velocity+PlayerCamera.camera_global_transform.basis*Vector3(input_dir.x,0,input_dir.y)*SPEED*100.0*dash_amount*delta
#		velocity = lerp(pre_dash_velocity,new_velocity,dash_amount)
		velocity = new_velocity
		dash_amount = max(dash_amount-dash_drain*delta*SPEED,0.0)
		if dash_amount == 0.0:
			velocity = pre_dash_velocity
			dashing = false
#			velocity = pre_dash_velocity
	else:
		dash_amount = min(dash_amount+dash_regen*delta, 1.0)
	get_tree().call_group("Player Data Recievers", "recieve_player_speed", self, SPEED)
	get_tree().call_group("Player Data Recievers", "recieve_player_dash_amount", self, dash_amount)
	move_and_slide()
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var rotation_vector = event.relative/Globals.Settings.Controls.MouseSensitivity
		PlayerCamera.gimbal_rotation_degrees.y += -rotation_vector.y*(float(!Globals.Settings.Controls.MouseInvertY)*2-1)
		rotation_degrees.y += -rotation_vector.x*(float(!Globals.Settings.Controls.MouseInvertX)*2-1)
	if event.is_action_pressed("fire"):
		var weapon = [left_weapon,right_weapon][weapon_idx]
		weapon.fire()
		weapon_idx = (weapon_idx+1)%2
	if event.is_action_pressed("dash"):
		pre_dash_velocity = velocity
		dashing = true
	if event.is_action_released("dash"):
		velocity = pre_dash_velocity
		dashing = false
	if event.is_action_pressed("pause"):
		var pause_ui = pause_screen.instantiate()
		add_child(pause_ui)
		pass
#	if event.is_action_pressed("dash") and can_dash:
#		velocity += PlayerCamera.camera_global_transform.basis*Vector3(0,0,-1)*SPEED*10.0
##		can_dash = false
#		last_dash_was_surface = is_on_floor() or is_on_wall()

func _ready():
	var Settings = (Globals.Settings as SettingsResource)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	(PlayerCamera as GimbalCamera).camera.fov = Settings.Graphics.PlayerCameraFOV
	(PlayerCamera as GimbalCamera).camera.keep_aspect = [Camera3D.KEEP_HEIGHT,Camera3D.KEEP_HEIGHT][Settings.Graphics.PlayerCameraFit]
#	self.

func recieve_player_camera_fov(fov):
	(PlayerCamera as GimbalCamera).camera.fov = fov

func recieve_player_camera_fit(fit):
	(PlayerCamera as GimbalCamera).camera.keep_aspect = [Camera3D.KEEP_HEIGHT,Camera3D.KEEP_HEIGHT][fit]
