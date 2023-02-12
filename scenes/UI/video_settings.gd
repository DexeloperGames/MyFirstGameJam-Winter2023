extends Control

@export var FOVSpinBox : SpinBox
@export var FOVSlider : HSlider
@export var FOVFitMenu : MenuButton
var current_FOV_control_node : Node
@export var WindowModeMenu : MenuButton
@export var ResolutionXSpinBox : SpinBox
@export var ResolutionYSpinBox : SpinBox
@export var VSyncCheckBox : CheckBox
@export var CapFramerateCheckBox : CheckBox
@export var MaximumFramerateSpinBox : SpinBox
@export var TextureResolutionMenu : MenuButton
@export var SettingsAppliedPanel : Panel
@export var RevertTimer : Timer
var settings_confirmed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	FOVFitMenu.get_popup().connect("id_pressed",_on_fov_fit_selected)
	WindowModeMenu.get_popup().connect("id_pressed",_on_window_mode_selected)
	TextureResolutionMenu.get_popup().connect("id_pressed", _on_texture_resolution_selected)
	load_settings_into_ui()
	pass # Replace with function body.

func load_settings_into_ui():
	var Settings = (Globals.Settings as SettingsResource)
	FOVSpinBox.value = Settings.Graphics.PlayerCameraFOV
	FOVSlider.value = Settings.Graphics.PlayerCameraFOV
	_on_fov_fit_selected(Settings.Graphics.PlayerCameraFit)
	_on_window_mode_selected(Settings.Graphics.WindowMode)
#	WindowModeMenu
	ResolutionXSpinBox.value = Settings.Graphics.FullscreenResolution.x
	ResolutionYSpinBox.value = Settings.Graphics.FullscreenResolution.y
	VSyncCheckBox.set_pressed_no_signal(Settings.Graphics.VSync)
	CapFramerateCheckBox.set_pressed_no_signal(Settings.Graphics.CapFramerate)
	MaximumFramerateSpinBox.value = Settings.Graphics.MaximumFramerate
	if Settings.Graphics.UseProcedualMaterials:
		TextureResolutionMenu.text = TextureResolutionMenu.get_popup().get_item_text(1)
	else:
		TextureResolutionMenu.text = TextureResolutionMenu.get_popup().get_item_text(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func send_player_camer_fov(fov):
	get_tree().call_group("Player Camera Recievers", "recieve_player_camera_fov", fov)
	pass

func send_player_camera_fit(fit):
	get_tree().call_group("Player Camera Recievers", "recieve_player_camera_fit", fit)

func _on_fov_spin_box_value_changed(value):
	if current_FOV_control_node == FOVSpinBox:
		(Globals.Settings as SettingsResource).Graphics.PlayerCameraFOV = value
		FOVSlider.value = value
		Globals.Settings.save()
		send_player_camer_fov(value)
	pass # Replace with function body.


func _on_fov_spin_box_gui_input(event):
	if not event is InputEventMouseMotion:
		current_FOV_control_node = FOVSpinBox
	pass # Replace with function body.


func _on_fov_slider_gui_input(event):
	if not event is InputEventMouseMotion:
		current_FOV_control_node = FOVSlider
	pass # Replace with function body.


func _on_fov_slider_value_changed(value):
	if current_FOV_control_node == FOVSlider:
		(Globals.Settings as SettingsResource).Graphics.PlayerCameraFOV = value
		FOVSpinBox.value = value
		send_player_camer_fov(value)
	pass # Replace with function body.


func _on_fov_slider_drag_ended(value_changed):
	Globals.Settings.save()
	pass # Replace with function body.

func _on_fov_fit_selected(idx):
#	print("yup selected indeed", idx)
	var popup = FOVFitMenu.get_popup()
	(Globals.Settings as SettingsResource).Graphics.PlayerCameraFit = idx
	FOVFitMenu.text = popup.get_item_text(popup.get_item_index(idx))
	send_player_camera_fit(idx)
#	Globals.Settings.save()

func _on_window_mode_selected(id):
	var popup = WindowModeMenu.get_popup()
	(Globals.Settings as SettingsResource).Graphics.WindowMode = id
	WindowModeMenu.text = popup.get_item_text(popup.get_item_index(id))
#	send_player_camera_fit(id)
#	Globals.Settings.save()

func _on_texture_resolution_selected(id):
	var popup = TextureResolutionMenu.get_popup()
	(Globals.Settings as SettingsResource).Graphics.UseProcedualMaterials = (id==1)
	TextureResolutionMenu.text = popup.get_item_text(popup.get_item_index(id))

func _on_resolution_x_spin_box_value_changed(value):
	(Globals.Settings as SettingsResource).Graphics.FullscreenResolution.x = value
	pass # Replace with function body.


func _on_resolution_y_spin_box_value_changed(value):
	(Globals.Settings as SettingsResource).Graphics.FullscreenResolution.y = value
	pass # Replace with function body.


func _on_v_sync_check_box_toggled(button_pressed):
	(Globals.Settings as SettingsResource).Graphics.VSync = button_pressed
	pass # Replace with function body.


func _on_cap_framerate_check_box_toggled(button_pressed):
	(Globals.Settings as SettingsResource).Graphics.CapFramerate = button_pressed
	pass # Replace with function body.


func _on_maximum_framerate_spin_box_value_changed(value):
	(Globals.Settings as SettingsResource).Graphics.MaximumFramerate = value
	pass # Replace with function body.


func _on_focus_entered():
#	print("git got focussss")
	pass # Replace with function body.


func _on_mouse_entered():
#	print("mouse entgeredd")
	pass # Replace with function body.


func _on_visibility_changed():
	if visible:
		print("i am see")
		Globals.Settings.save("res://revertable_settings.tres")
	pass # Replace with function body.

func revert_settings():
	print("REVERTING")
	var reverted_settings = SettingsResource.load_from("res://revertable_settings.tres")
	print(reverted_settings)
	if reverted_settings:
		print("YUP")
		Globals.Settings = reverted_settings
		Globals.Settings.load_settings()
		load_settings_into_ui()

func _on_apply_settings_button_pressed():
	Globals.Settings.save()
	RevertTimer.start()
	SettingsAppliedPanel.visible = true
	settings_confirmed = false
	(Globals.Settings as SettingsResource).Graphics.load_settings()
	pass # Replace with function body.


func _on_keep_changes_button_toggled(button_pressed):
	pass # Replace with function body.


func _on_revert_button_pressed():
	revert_settings()
	SettingsAppliedPanel.visible = false
	RevertTimer.stop()
	pass # Replace with function body.


func _on_revert_timer_timeout():
	if !settings_confirmed:
		revert_settings()
		SettingsAppliedPanel.visible = false
	pass # Replace with function body.


func _on_keep_changes_button_pressed():
	settings_confirmed = true
	SettingsAppliedPanel.visible = false
	pass # Replace with function body.
