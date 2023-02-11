extends Control

@export var current_menu_node : Node
@export var title_menu : PackedScene
@export var options_menu : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
