extends Control

@export var MasterVolumeSlider : HSlider
@export var LazerGunVolumeSlider : HSlider
# Called when the node enters the scene tree for the first time.
func _ready():
	var Settings = (Globals.Settings as SettingsResource)
	MasterVolumeSlider.value = Settings.Audio.MasterVolume
	LazerGunVolumeSlider.value = Settings.Audio.LazerGunVolume
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_master_volume_slider_value_changed(value):
	(Globals.Settings as SettingsResource).Audio.MasterVolume = value
	(Globals.Settings as SettingsResource).Audio.load_settings()
	pass # Replace with function body.


func _on_lazer_gun_volume_slider_value_changed(value):
	(Globals.Settings as SettingsResource).Audio.LazerGunVolume = value
	(Globals.Settings as SettingsResource).Audio.load_settings()
	pass # Replace with function body.


func _on_master_volume_slider_drag_ended(value_changed):
	Globals.Settings.save()
	pass # Replace with function body.


func _on_lazer_gun_volume_slider_drag_ended(value_changed):
	Globals.Settings.save()
	pass # Replace with function body.
