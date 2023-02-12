extends Control

@export var current_menu_node : Node
@export var title_menu : PackedScene
@export var options_menu : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	switch_to_title()
	pass # Replace with function body.

func clear_current_menu():
	for child in current_menu_node.get_children():
		child.queue_free()
		child.visible = false

func switch_to_menu_scene(menu_scene : PackedScene):
	clear_current_menu()
	var menu_instance = menu_scene.instantiate()
	current_menu_node.add_child(menu_instance)

func switch_to_title():
	switch_to_menu_scene(title_menu)

func switch_to_options():
	switch_to_menu_scene(options_menu)

func resume():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused=false
	queue_free()
	pass

func quit_to_main_menu():
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu_ui.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
