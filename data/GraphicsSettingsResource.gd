extends Resource
class_name GraphicsSettings

@export var PlayerCameraFOV : float = 90.0
@export var PlayerCameraFit : int = 0
@export var WindowMode : int = 0
@export var Boarderless : bool = false
@export var FullscreenResolution : Vector2i = Vector2i(1920,1080)
@export var VSync : bool = true
@export var CapFramerate : bool = false
@export var MaximumFramerate : int = 60
@export var UseProcedualMaterials : bool = true

func _init():
	pass

func update_window_settings():
	var new_mode = [
			DisplayServer.WINDOW_MODE_WINDOWED,
			DisplayServer.WINDOW_MODE_FULLSCREEN,
			DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	][WindowMode]
	DisplayServer.window_set_mode(new_mode)
	if new_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(FullscreenResolution)
		pass
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if VSync else DisplayServer.VSYNC_DISABLED)
	if CapFramerate:
		Engine.max_fps = MaximumFramerate
	else:
		Engine.max_fps = 0

func load_settings():
	update_window_settings()
	if UseProcedualMaterials:
		Globals.enable_procedual_concrete()
	else:
		Globals.disable_procedual_concrete()
#	DisplayServer.window_set_mode(WindowMode)
