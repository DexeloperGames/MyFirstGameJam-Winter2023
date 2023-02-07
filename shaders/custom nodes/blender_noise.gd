
@tool
class_name VisualShaderNodeBlenderNoise
extends VisualShaderNodeCustom



func _get_name():
	return "Noise Texture"


func _get_category():
	return "Blender/Textures"


func _get_description():
	return "Generate fractal Perlin noise"


func _init():
	prints(Time.get_datetime_string_from_system())
	set_input_port_default_value(0, 3)
	set_input_port_default_value(2, 5.0)
	set_input_port_default_value(3, 2.0)
	set_input_port_default_value(4, 0.5)
	set_input_port_default_value(5, 0.0)


func _get_return_icon_type():
	return PORT_TYPE_VECTOR_3D


func _get_input_port_count():
	return 6


func _get_input_port_name(port):
	return [
			"Noise Dimensions",
			"Vector",
			"Scale",
			"Detail",
			"Roughness",
			"Distortion"
			][port]


func _get_input_port_type(port):
	return [
			PORT_TYPE_SCALAR_UINT,
			PORT_TYPE_VECTOR_4D,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR
			][port]

func _get_output_port_count():
	return 2


func _get_output_port_name(port):
	return ["Fac", "Color"][port]


func _get_output_port_type(port):
	return [PORT_TYPE_SCALAR,PORT_TYPE_VECTOR_4D][port]


func _get_global_code(mode):
	return '#include "res://shaders/includes/blender_noise.gdshaderinc"'
	

func _get_code(input_vars, output_vars, mode, type):
#	return ""
	var dim_str = input_vars[0] if input_vars[0] else "3"
	var vec_str = input_vars[1] if input_vars[1] else "vec4(UV,0.0,0.0)"
	var scale_string = input_vars[2] if input_vars[2] else "5.0"
	var detail_str = input_vars[3] if input_vars[3] else "2.0"
	var rough_str = input_vars[4] if input_vars[4] else "0.5"
	var distor_str = input_vars[5] if input_vars[5] else "0.0"
	
	var o_fac_str = output_vars[0]
	var o_color_str = output_vars[1]
#	return "o_color_str = vec4(1.0);"
	return """
	switch(clamp({dim},1,4)):
		case 1:
			node_noise_texture_1d({vec}.xyz,{vec}.x,{scale},{detail},{rough},{distor},{o_fac},{o_col}); break;
		case 2:
			node_noise_texture_2d({vec}.xyz,0.0,{scale},{detail},{rough},{distor},{o_fac},{o_col}); break;
		case 3:
			node_noise_texture_3d({vec}.xyz,0.0,{scale},{detail},{rough},{distor},{o_fac},{o_col}); break;
		case 4:
			node_noise_texture_4d({vec}.xyz,{vec}.w,{scale},{detail},{rough},{distor},{o_fac},{o_col}); break;
	""".format({
		"dim":dim_str,
		"vec":vec_str,
		"scale":scale_string,
		"detail":detail_str,
		"rough":rough_str,
		"distor":distor_str,
		"o_fac":o_fac_str,
		"o_col":o_color_str
	})
