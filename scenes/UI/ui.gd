extends Control

@export var score_label : Label
@export var speed_factor_label : Label
@export var timer_label : Label
@export var score : int = 0:
	set(n_score):
		score = n_score
		if not is_inside_tree(): await ready
		score_label.text = "SCORE: %05d"%score
@export var speed_factor : float = 1.0:
	set(n_factor):
		speed_factor = n_factor
		if not is_inside_tree(): await ready
		speed_factor_label.text = "SPEED FACTOR: %4.3fx"%speed_factor
var max_speed : float = 0.0
var timer_started = false
var start_time : int = 0
var timer_time : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
#	Engine.max_fps = 60
	RenderingServer.connect("frame_pre_draw",_on_frame_draw_pre)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$Label.text = str(Performance.TIME_FPS)
#	$"VBoxContainer/Label".text = str(1/delta)
	
	pass

var target_dict : Dictionary = {}
func recieve_current_target_for(object,target):
	target_dict[object] = target
#	$Label2.text = "Targets for thigns:\n%s"%target_dict

func recieve_player_speed(player, speed):
	speed_factor = speed/(player as Player).base_speed
	max_speed = max(speed,max_speed)
	pass
#	$"VBoxContainer/Speed Label".text = "SPEED: %4.3f"%speed

func recieve_player_dash_amount(player, dash_amount):
	pass
#	$"VBoxContainer/Dash Label".text = "DASH: %4.3f"%dash_amount

func recieve_required_primitive_counts(primitive_counts):
	pass
	$"Remaining Primitives UI".display_counts = primitive_counts

func _on_frame_draw_pre():
	var frame_time = Time.get_ticks_usec()
	if !timer_started:
		start_time = frame_time
		timer_started = true
	else:
		timer_time = frame_time-start_time
		var time_seconds = timer_time/1.0e+6
		timer_label.text = "%02d:%02.3f"%[floor(time_seconds/60.0),fmod(time_seconds,60)]
	pass
