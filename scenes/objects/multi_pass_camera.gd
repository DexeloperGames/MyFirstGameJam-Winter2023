extends Camera3D
class_name MultiPassCamera

@export var base_camera : Camera3D
# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.connect("frame_pre_draw",_on_frame_draw_pre)
	pass # Replace with function body.

func sync_cameras():
	keep_aspect = base_camera.keep_aspect
	environment = base_camera.environment
	attributes = base_camera.attributes
	h_offset = base_camera.h_offset
	v_offset = base_camera.v_offset
	doppler_tracking = base_camera.doppler_tracking
	projection = base_camera.projection
	fov = base_camera.fov
	near = base_camera.near
	far = base_camera.far
	v_offset = base_camera.v_offset
	size = base_camera.size
	frustum_offset = base_camera.frustum_offset
	global_transform = base_camera.global_transform

func _on_frame_draw_pre():
	if base_camera:
		sync_cameras()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
