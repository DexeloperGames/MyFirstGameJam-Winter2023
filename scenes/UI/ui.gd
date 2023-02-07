extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$Label.text = str(Performance.TIME_FPS)
	$Label.text = str(1/delta)
	pass

var target_dict : Dictionary = {}
func recieve_current_target_for(object,target):
	target_dict[object] = target
	$Label2.text = "Targets for thigns:\n%s"%target_dict
