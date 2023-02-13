extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",_on_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_entered(thing):
	if thing is Player:
		thing.trigger_win()
