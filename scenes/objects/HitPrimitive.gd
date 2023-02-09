extends Node3D
class_name HitPrimitive

#@export_color_no_alpha var color = Color.WHITE
@export var mesh : MeshInstance3D
@export var score_points : int = 100
@export var face_position_array : Array[Vector3]
@export var face_normal_array : Array[Vector3]
@export var collision_shape : CollisionShape3D
@export var particle_speed : float = 0
var hit_particle = load("res://scenes/objects/hit_particle.tscn")
#@export var thing : Array[Vector3]
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Rotate Y")
	pass # Replace with function body.


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

func hit(thing):
	print("yeahthing")
	if thing is LazerGun:
		if thing.wielder is Player:
			thing.wielder.score += score_points
	spawn_hit_particles()
	queue_free()
