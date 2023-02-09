extends Node3D

@export var firing_from_node : Node3D
@export var relative_firing_direction : Vector3 = Vector3.RIGHT
@export_flags_3d_physics var target_layers : int = 1
#@export var owner : Nodez
@export var wielder : Node
@export var SFX_Player : AudioStreamPlayer3D
var latest_ray_hit
var targeting_object
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var ray_start = firing_from_node.global_position
	var ray_end = firing_from_node.global_transform*(relative_firing_direction*1000.0)
	var query = PhysicsRayQueryParameters3D.create(ray_start,ray_end, target_layers)
	var latest_ray_hit = space_state.intersect_ray(query)
#	print(ray_start)
#	print(ray_end)
	if !latest_ray_hit.is_empty():
#		print("hit")
#		print(latest_ray_hit)
		targeting_object = latest_ray_hit["collider"]
	else:
#		print("no hit")
		targeting_object = null
	get_tree().call_group("Debug Data Recievers", "recieve_current_target_for", self, targeting_object)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

signal hit(object)

func fire():
	SFX_Player.play()
	if targeting_object:
		emit_signal("hit", targeting_object)
		
		if (targeting_object.get_parent() as Node).has_method("hit"):
			targeting_object.get_parent().call("hit", self)
#		owner
	pass
