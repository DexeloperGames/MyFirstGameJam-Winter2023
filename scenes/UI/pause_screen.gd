extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_options_pressed():
	get_tree().call_group("Main Menu", "switch_to_options")
	pass # Replace with function body.


func _on_play_pressed():
	get_tree().call_group("Main Menu", "resume")
	pass # Replace with function body.


func _on_quit_to_menu_pressed():
	get_tree().call_group("Main Menu", "quit_to_main_menu")
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().call_group("Main Menu", "resume")
