extends Node

var Settings = SettingsResource.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	ResourceSaver.save(Settings, "res://settings.tscn")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("pause"):
		print("PAUSE PRESSED")
		get_tree().paused = !get_tree().paused
