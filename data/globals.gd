extends Node

var Settings = SettingsResource.new()
var preloads : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	ResourceSaver.save(Settings, "res://settings.tscn")
	RenderingServer.connect("frame_pre_draw",_on_frame_change_pre)
	preloads.append(preload("res://scenes/objects/cool_hit_text.tres"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("pause"):
		print("PAUSE PRESSED")
		get_tree().paused = !get_tree().paused

func _on_frame_change_pre():
	RenderingServer.global_shader_parameter_set("engine_time", Time.get_ticks_usec()/1.0e+6)
	pass
