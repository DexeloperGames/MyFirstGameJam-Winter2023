extends Resource
class_name ColorSettings

@export var PrimitiveColors : Array[Color] = [	Color.RED,
												Color.GREEN,
												Color.BLUE,
												Color.MAGENTA,
												Color.CYAN
												]

func load_settings():
	for i in range(len(PrimitiveColors)):
		RenderingServer.global_shader_parameter_set("primitive_color_%s"%i, PrimitiveColors[i])
