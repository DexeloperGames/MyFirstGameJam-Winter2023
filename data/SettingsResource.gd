extends Resource
class_name SettingsResource

@export var Controls : ControlSettings = ControlSettings.new()
@export var Colors : ColorSettings = ColorSettings.new()
@export var Graphics : GraphicsSettings = GraphicsSettings.new()
@export var Audio : AudioSettings = AudioSettings.new()
#class GraphicsSettings:
#	@export var test = "yeah"
	

#@export var graphics = GraphicsSettings.new()

func _init():
#	MouseSensitivity = m_sens*2
#	primitive_colors_array = p_colors
#	print("yeah")
#	Graphics.test = "indeedio"
#	graphics.test = "indeedio"
	pass

func save(path : String = Globals.SettingsPath):
	prints("Saving settings to path:", path)
	ResourceSaver.save(self, path)
	pass


static func load_from(path : String = Globals.SettingsPath):
#	path = "res://testsettings.tres"
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path)
	else: return null
	pass

func load_settings():
	Colors.load_settings()
	Controls.load_settings()
	Graphics.load_settings()
	Audio.load_settings()
