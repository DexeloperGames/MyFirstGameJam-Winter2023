extends Button

@export var mapping_aciton_name : String
@export var mapping_input_event : InputEvent
@export var mapping_show_index : int = 0
var scanning_inputs = false

var input_map = (Globals.Settings as SettingsResource).Controls.InputMapping
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _on_pressed)
	await RenderingServer.frame_pre_draw
	update_button_text()
	input_map = (Globals.Settings as SettingsResource).Controls.InputMapping
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_button_text():
	input_map = (Globals.Settings as SettingsResource).Controls.InputMapping
	if mapping_aciton_name in input_map:
		var event = input_map[mapping_aciton_name][mapping_show_index]
#		print("checking input action array size: ", len(input_map[mapping_aciton_name]))
		if event is InputEventKey:
#			print("this was a key press for action ", mapping_aciton_name)
#			print(event)
			text = event.as_text_physical_keycode()
		if event is InputEventMouseButton:
#			print("this was a mouse click")
#			print(event)
			text = event.as_text()
		if event is InputEventJoypadButton:
#			print(event)
#			print("contrlr")
			text = event.as_text()

func _on_pressed():
	if !scanning_inputs:
		text = "???"
		scanning_inputs = true
	release_focus()
	pass

func _input(event):
	if scanning_inputs:
#		print("got event")
		if [InputEventKey, InputEventMouseButton, InputEventJoypadButton].any(func(check): return event is check) and event.is_pressed():
#			print("yup event")
#			print(event)
#			if event is InputEventKey:
#				print("this was a key press")
#			if event is InputEventMouse:
#				print("this was a mouse click")
#			print(input_map[mapping_aciton_name][mapping_show_index])
			input_map[mapping_aciton_name][mapping_show_index] = event
#			print(input_map[mapping_aciton_name][mapping_show_index])
			update_button_text()
			Globals.Settings.save()
			pass
		if event.is_pressed():
			scanning_inputs = false
