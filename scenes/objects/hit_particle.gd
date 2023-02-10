extends RigidBody3D
class_name HitParticle

@export var collision_shape : Shape3D
@export var particle_mesh : Mesh
@export var lifetime : float = 2
@export var collision_scale : float = 0.1
@export var particle_material : Material
var hit_text = preload("res://scenes/objects/cool_hit_text.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
#	prints("\n", self, "collision_shape", collision_shape, collision_shape.shape)
	$CollisionShape3D.shape = collision_shape
#	prints(self, "collision_shape_after", collision_shape)
	$MeshInstance3D.mesh = particle_mesh
	$MeshInstance3D.material_override = particle_material
	$Timer.wait_time = lifetime
	$Timer.start()
	
	$CollisionShape3D.scale = Vector3(collision_scale, collision_scale, collision_scale)
	$MeshInstance3D.scale = Vector3(collision_scale,collision_scale,collision_scale)
#	await get_tree().physics_frame
#	await get_tree().physics_frame
#	scale = Vector3(0.1,0.1,0.1)
#	self.linear_velocity
#	self.global_
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
##	scale = Vector3(0.1,0.1,0.1)
#	pass
func spawn_hit_text(facing_position = Vector3.ZERO):
	var new_hit_text = hit_text.instantiate()
	new_hit_text.number = 10
	new_hit_text.color_index = particle_material.get_shader_parameter("Color_Index")
	add_sibling(new_hit_text)
	new_hit_text.scale = Vector3(2,2,2)
	
	new_hit_text.global_position = global_position
	(new_hit_text as Node3D).look_at(facing_position)

func hit(thing):
	print("Particle hit by ", thing)
	var facing = Vector3.ZERO
	if thing is LazerGun:
		if thing.wielder is Player:
			thing.wielder.score += 10
			facing = thing.wielder.global_position
	spawn_hit_text(facing)
	$MeshInstance3D.material_override = null
	queue_free()
	pass


func _on_timer_timeout():
	$MeshInstance3D.material_override = null
	queue_free()
	pass # Replace with function body.
