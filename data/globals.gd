extends Node

var Settings = SettingsResource.new()
var SettingsPath = "user://testsettings.tres"
var preloads : Array
var concrete_material : ShaderMaterial = preload("res://scenes/levels/concrete_material.tres")
var procedual_concrete_shader : Shader = preload("res://scenes/levels/procedual_concretefr.tres")
var basic_concrete_shader : Shader = preload("res://scenes/levels/basic_concrete.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	ResourceSaver.save(Settings, "res://settings.tscn")
	RenderingServer.connect("frame_pre_draw",_on_frame_change_pre)
	preloads.append(preload("res://scenes/objects/cool_hit_text.tres"))
	Settings = SettingsResource.load_from("res://testsettings.tres")
	Settings.load_settings()
	pass # Replace with function body.


func enable_procedual_concrete():
	concrete_material.shader = procedual_concrete_shader

func disable_procedual_concrete():
	concrete_material.shader = basic_concrete_shader

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _input(event):
#	if event.is_action_pressed("pause"):
#		print("PAUSE PRESSED")
#		get_tree().paused = !get_tree().paused

func _on_frame_change_pre():
	RenderingServer.global_shader_parameter_set("engine_time", Time.get_ticks_usec()/1.0e+6)
	pass
