@tool
class_name VisualShaderNodeBlenderBumpNode
extends VisualShaderNodeCustom


func _get_name():
	return "Bump"


func _get_category():
	return "Blender/Vector"


func _get_description():
	return "Generate a perturbed normal from a height texture for bump mapping. Typically used for faking highly detailed surfaces"

func _init():
	set_input_port_default_value(0, false)
	set_input_port_default_value(1, 1.0)
	set_input_port_default_value(2, 1.0)

func _get_return_icon_type():
	return PORT_TYPE_VECTOR_3D


func _get_input_port_count():
	return 5


func _get_input_port_name(port):
	return [
			"Invert",
			"Strength",
			"Distance",
			"Height",
			"Normal"
			][port]


func _get_input_port_type(port):
	return [
			PORT_TYPE_BOOLEAN,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR,
			PORT_TYPE_VECTOR_3D
			][port]


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return "Normal"


func _get_output_port_type(port):
	return PORT_TYPE_VECTOR_3D

func _get_global_code(mode):
	return '#include "res://shaders/includes/bump.gdshaderinc"'

func _get_code(input_vars, output_vars, mode, type):
	var invert_string = input_vars[0] if input_vars[0] else "false"
	var strength_string = input_vars[1] if input_vars[1] else "1.0"
	var distance_string = input_vars[2] if input_vars[2] else "1.0"
	var height_string = input_vars[3] if input_vars[3] else "0.0"
	var normal_string = input_vars[4] if input_vars[4] else "NORMAL"
	return output_vars[0] + " = bump({0},{1},{2},{3},VERTEX,{4});".format([height_string,distance_string,strength_string,invert_string,normal_string])
