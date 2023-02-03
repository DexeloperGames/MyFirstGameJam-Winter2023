extends Node3D
class_name HitPrimitive

#@export_color_no_alpha var color = Color.WHITE
@export var mesh : MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Rotate Y")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
