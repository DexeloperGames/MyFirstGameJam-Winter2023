extends Node3D
class_name CoolHitText

@export var number : int = 200
@export var text : String = "+200"
@export var text_color : Color
@export var color_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance3D.mesh.text = "+%s"%number
	$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("Color_Index", color_index)
	$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("Spawn_Time", Time.get_ticks_usec()/1.0e+6)
	$AnimationPlayer.play("Hit")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	queue_free()
	pass # Replace with function body.
