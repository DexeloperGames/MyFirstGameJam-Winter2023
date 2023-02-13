extends Control

@export var mouse_sensitivity_spinbox : SpinBox
@export var mouse_sensitivity_slider : HSlider
@export var mouse_invert_x_checkbox : CheckBox
@export var mouse_invert_y_checkbox : CheckBox
var current_updated_control_node : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	var Settings = (Globals.Settings as SettingsResource)
	mouse_sensitivity_spinbox.value = Settings.Controls.MouseSensitivity
	mouse_sensitivity_slider.value = convert_sensitivity_to_percent(Settings.Controls.MouseSensitivity)
	mouse_invert_x_checkbox.set_pressed_no_signal(Settings.Controls.MouseInvertX)
	mouse_invert_y_checkbox.set_pressed_no_signal(Settings.Controls.MouseInvertY)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func update_mouse_sensitivity(value):
#	print("Updating Mouse to ", value)
	(Globals.Settings as SettingsResource).Controls.MouseSensitivity = value

func convert_sensitivity_to_percent(sens):
	return 1.0/sens

func _on_spin_box_value_changed(value):
	
	if current_updated_control_node == mouse_sensitivity_spinbox:
		update_mouse_sensitivity(value)
		mouse_sensitivity_slider.value = convert_sensitivity_to_percent(value)
		Globals.Settings.save()
	pass # Replace with function body.


func _on_spin_box_focus_entered():
#	print("SPINBOX FOCUS")
	current_updated_control_node = mouse_sensitivity_spinbox
	pass # Replace with function body.


func _on_h_slider_value_changed(value):
	if current_updated_control_node == mouse_sensitivity_slider:
		var new_value = convert_sensitivity_to_percent(value)
		update_mouse_sensitivity(new_value)
		mouse_sensitivity_spinbox.value = new_value
		
	pass # Replace with function body.


func _on_h_slider_focus_entered():
	current_updated_control_node = mouse_sensitivity_slider
	pass # Replace with function body.


func _on_spin_box_gui_input(event):
#	print("SPINBOX FOCUS")
	if not event is InputEventMouseMotion:
		current_updated_control_node = mouse_sensitivity_spinbox
	pass # Replace with function body.


func _on_h_slider_drag_ended(value_changed):
	Globals.Settings.save()
	pass # Replace with function body.


func _on_invert_x_checkbox_toggled(button_pressed):
	(Globals.Settings as SettingsResource).Controls.MouseInvertX = button_pressed
	Globals.Settings.save()
	pass # Replace with function body.


func _on_invert_y_checkbox_toggled(button_pressed):
	(Globals.Settings as SettingsResource).Controls.MouseInvertY = button_pressed
	Globals.Settings.save()
	pass # Replace with function body.
