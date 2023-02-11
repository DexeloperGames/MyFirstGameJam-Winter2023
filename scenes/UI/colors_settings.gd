extends Control

@export var primitive_color_picker_0 : ColorPickerButton
@export var primitive_color_picker_1 : ColorPickerButton
@export var primitive_color_picker_2 : ColorPickerButton
@export var primitive_color_picker_3 : ColorPickerButton
@export var primitive_color_picker_4 : ColorPickerButton
# Called when the node enters the scene tree for the first time.
func _ready():
#	var i = 0
#	while RenderingServer.global_shader_parameter_get("primitive_color_0") == null:
#		print("try ", i)
#		print(RenderingServer.global_shader_parameter_get("primitive_color_0"))
#		i+=1
	primitive_color_picker_0.color = (Globals.Settings as SettingsResource).primitive_colors_array[0]
	primitive_color_picker_1.color = (Globals.Settings as SettingsResource).primitive_colors_array[1]
	primitive_color_picker_2.color = (Globals.Settings as SettingsResource).primitive_colors_array[2]
	primitive_color_picker_3.color = (Globals.Settings as SettingsResource).primitive_colors_array[3]
	primitive_color_picker_4.color = (Globals.Settings as SettingsResource).primitive_colors_array[4]
	$AnimationPlayer.play("Spin")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_primitive_1_color_picker_color_changed(color):
	RenderingServer.global_shader_parameter_set("primitive_color_0", color)
	pass # Replace with function body.


func _on_primitive_2_color_picker_color_changed(color):
	RenderingServer.global_shader_parameter_set("primitive_color_1", color)
	pass # Replace with function body.


func _on_primitive_3_color_picker_color_changed(color):
	RenderingServer.global_shader_parameter_set("primitive_color_2", color)
	pass # Replace with function body.


func _on_primitive_4_color_picker_color_changed(color):
	RenderingServer.global_shader_parameter_set("primitive_color_3", color)
	pass # Replace with function body.


func _on_primitive_5_color_picker_color_changed(color):
	RenderingServer.global_shader_parameter_set("primitive_color_4", color)
	pass # Replace with function body.
