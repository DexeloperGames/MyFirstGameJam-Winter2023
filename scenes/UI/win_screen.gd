extends Control

@export var score : int
@export var time : float
@export var next_level : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_display():
	$VBoxContainer/score.text = "score:%s"%score
	$VBoxContainer/time.text = "time: %s seconds"%time

func _on_play_pressed():
	get_tree().change_scene_to_packed(next_level)
#	get_tree().
	pass # Replace with function body.


func _on_options_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu_ui.tscn")
	pass # Replace with function body.
