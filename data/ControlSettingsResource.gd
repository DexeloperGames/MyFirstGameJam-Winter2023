extends Resource
class_name ControlSettings

@export var MouseSensitivity : float = 7.7
@export var MouseInvertX : bool = false
@export var MouseInvertY : bool = false
@export var InputMapping : Dictionary

func _init():
	var actions = InputMap.get_actions()
#	print("actions")
#	print(actions)
	for action in actions:
#		print("input actions ", action)
		InputMapping[action] = InputMap.action_get_events(action)
#	print("check")
#	print(InputMapping)

func load_settings():
#	print("loading control settings rn")
	for action in InputMapping:
#		print("computing action ", action)
		InputMap.action_erase_events(action)
		for event in InputMapping[action]:
#			print("applying event ", event, " to action ", action)
			InputMap.action_add_event(action,event)
	pass
