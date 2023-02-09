extends RigidBody3D
class_name HitParticle

@export var collision_shape : Shape3D
@export var particle_mesh : Mesh
@export var lifetime : float = 2
@export var collision_scale : float = 0.1
@export var particle_material : Material 
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

func hit(thing):
	print("Particle hit by ", thing)
	if thing is LazerGun:
		if thing.wielder is Player:
			thing.wielder.score += 10
	queue_free()
	pass


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
