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
