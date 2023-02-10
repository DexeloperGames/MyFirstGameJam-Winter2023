@tool
extends Node3D

@export var size : Vector2 = Vector2.ONE:
	set(n_size):
		print("set getting size ig")
		size = n_size
		if not is_inside_tree(): await ready
		$MeshInstance3D.mesh.size = n_size
		$MeshInstance3D.position.y = size.y/2.0
		$MeshInstance3D/StaticBody3D/CollisionShape3D.shape.size.x = n_size.x
		$MeshInstance3D/StaticBody3D/CollisionShape3D.shape.size.y = n_size.y
@export var resolution : Vector2i = Vector2i(128,128)
@export var active : bool = false
@export var next_door : Node
@export var required_primitive_counts : Array[Vector2i] = [Vector2i.ZERO, Vector2i.ZERO,Vector2i.ZERO,Vector2i.ZERO,Vector2i.ZERO]
@export var primitives_display : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	send_required_primitive_counts()
	pass # Replace with function body.

func send_required_primitive_counts():
	get_tree().call_group("Required Primitives Recievers", "recieve_required_primitive_counts", required_primitive_counts)
#	
	var thing = $"SubViewport/Remaining Primitives UI"
	if thing != null:
		thing.display_counts = required_primitive_counts
	

func check_open():
	if required_primitive_counts.all(func(vec): return vec.x == vec.y):
		$MeshInstance3D/StaticBody3D.collision_layer = 0
		$MeshInstance3D/StaticBody3D.collision_mask = 0
		$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("Opened", true)

func recieve_primitive_hit(primitive_id):
	if active:
		required_primitive_counts[primitive_id].x += 1
		check_open()
		send_required_primitive_counts()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		send_required_primitive_counts()
	pass
