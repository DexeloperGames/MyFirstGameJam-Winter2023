extends Resource
class_name SettingsResource

@export var MouseSensitivity : float = 7.7 #dots per degree
@export var primitive_colors_array : Array[Color] = [Color.RED, Color.GREEN, Color.BLUE, Color.MAGENTA, Color.CYAN]
func _init(m_sens = 7.7, p_colors : Array[Color]= [Color.RED, Color.GREEN, Color.BLUE, Color.MAGENTA, Color.CYAN]):
	MouseSensitivity = m_sens
	primitive_colors_array = p_colors
	print("yeah")

