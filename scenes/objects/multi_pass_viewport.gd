extends SubViewport
class_name MultiPassViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.connect("frame_pre_draw",_on_frame_draw_pre)
	pass # Replace with function body.

func sync_viewports():
	var parent_viewport = get_viewport()
	size = parent_viewport.size

func _on_frame_draw_pre():
	sync_viewports()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
