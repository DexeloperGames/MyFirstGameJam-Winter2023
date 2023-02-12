extends Resource
class_name AudioSettings

@export var MasterVolume : float = 1.0
@export var LazerGunVolume : float = 1.0

func load_settings():
	var master_index = AudioServer.get_bus_index("Master")
	var lazergun_index = AudioServer.get_bus_index("LazerGun")
	AudioServer.set_bus_volume_db(master_index,linear_to_db(MasterVolume))
	AudioServer.set_bus_volume_db(lazergun_index,linear_to_db(LazerGunVolume))
