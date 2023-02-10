@tool
extends Control

@export var container_array : Array[Node]
@export var label_settings : LabelSettings
@export var display_counts : Array[Vector2i] = [Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0)]
# Called when the node enters the scene tree for the first time.
func _ready():
	container_array = [$"VBoxContainer/Tetrahedron Count Container",
						$"VBoxContainer/Cube Count Container",
						$"VBoxContainer/Octahedron Count Container",
						$"VBoxContainer/Dodecahedron Count Container",
						$"VBoxContainer/Icohedron Count Container"]
	$AnimationPlayer.play("Spin")
	pass # Replace with function body.

func update_text_label_sizes():
	if not is_inside_tree(): await ready
	var container_height = container_array[0].size.y
	label_settings.font_size = container_height*0.7
	for container in container_array:
		if container.get_child(1) == null: return
		container.get_child(1).label_settings = label_settings
	pass

func update_display_text():
	if not is_inside_tree(): await ready
	for i in range(len(display_counts)):
		var amounts = display_counts[i]
		var container = container_array[i]
		if amounts.y == 0:
			container.visible = false
		else:
			container.visible = true
		container.get_child(1).text = "%s/%s"%[amounts.x,amounts.y]
		pass
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_text_label_sizes()
	update_display_text()
	pass


func _on_resized():
	print("HEY RESIZE")
	update_text_label_sizes()
	pass # Replace with function body.
