extends Node3D
class_name HitPrimitive

#@export_color_no_alpha var color = Color.WHITE
@export var mesh : MeshInstance3D
@export var score_points : int = 100
@export var face_position_array : Array[Vector3]
@export var face_normal_array : Array[Vector3]
@export var collision_shape : CollisionShape3D
@export var particle_speed : float = 1
@export var primitive_id : int = 0
@export var mesh_visible : bool = true:
	set(n_visible):
		mesh_visible = n_visible
		if not is_inside_tree(): await ready
		mesh.visible = n_visible
var hit_particle = preload("res://scenes/objects/hit_particle.tscn")
var hit_text = preload("res://scenes/objects/cool_hit_text.tscn")
#@export var thing : Array[Vector3]
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Rotate Y")
	pass # Replace with function body.

func start_spawn_animation(start_position):
	mesh.get_surface_override_material(0).set_shader_parameter("Spawned", false)
	mesh.get_surface_override_material(0).set_shader_parameter("Spawn_Time", Time.get_ticks_usec()/1.0e+6)
	mesh.get_surface_override_material(0).set_shader_parameter("Fade_Start_Position", start_position)
	self.mesh_visible = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
#	pass

func spawn_hit_particles():
	for i in range(len(face_position_array)):
		var new_hit_particle = hit_particle.instantiate()
		new_hit_particle.collision_shape = collision_shape.shape
		new_hit_particle.particle_mesh = mesh.mesh #lol
		new_hit_particle.particle_material = mesh.get_surface_override_material(0)
		
		var norm = face_normal_array[i]
		var pos = face_position_array[i]
		add_sibling(new_hit_particle)
		
		new_hit_particle.global_position = global_transform*pos
		new_hit_particle.linear_velocity = Vector3(norm.x*particle_speed,2.0,norm.z*particle_speed)
#		new_hit_particle.scale = Vector3(0.1, 0.1, 0.1)
		new_hit_particle.global_scale(Vector3(0.1,0.1,0.1))

func spawn_hit_text(facing_position = Vector3.ZERO):
	var new_hit_text = hit_text.instantiate()
	new_hit_text.number = score_points
	new_hit_text.color_index = mesh.get_surface_override_material(0).get_shader_parameter("Color_Index")
	add_sibling(new_hit_text)
	new_hit_text.global_position = global_position
	(new_hit_text as Node3D).look_at(facing_position)

func hit(thing):
	print("yeahthing")
	var facing = Vector3.ZERO
	if thing is LazerGun:
		if thing.wielder is Player:
			thing.wielder.score += score_points
			facing = thing.wielder.global_position+Vector3(0,1.57,0)
	spawn_hit_particles()
	spawn_hit_text(facing)
	mesh.set_surface_override_material(0, null)
	get_tree().call_group("Primitive Hit Recievers", "recieve_primitive_hit", primitive_id)
	queue_free()
