extends Node

var Settings = SettingsResource.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceSaver.save(Settings, "res://settings.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
