extends Node
class_name SpawnSystem

signal spawn_wave(num: int)

@export var difficulty_curve: Curve

@export var time_curve: Curve

@export var minute_max_diff : float = 15.0

@export var diff_coeff: float = 15.0

#@onready var spawn_timer: Timer = get_tree().create_timer()
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_wave_timeout)
	reset_wave_time()

func normalize_t(t: float) ->float:
	return t / minute_max_diff

func sample_diff_curve(d_time: float)->float:
	#
	var offset :float= normalize_t(d_time)
	
	var sample :float= difficulty_curve.sample(offset)
	
	return sample * diff_coeff

func print_thingy()->void:
	var thingy := sample_diff_curve(GameGlobals.d_time / 60)
	
	print("how many things i wish i could spawn: ", ceil(thingy))
	
	spawn_wave.emit(int(ceil(thingy)))

func reset_wave_time()->void:
	
	var offset := normalize_t(GameGlobals.d_time / 60)
	
	var sample := time_curve.sample(offset)
	
	spawn_timer.wait_time = sample * 10
	
	print("spawn timer wait: ",spawn_timer.wait_time )

func _on_wave_timeout()->void:
	#spawn_timer.wait_time -= 0.1 if spawn_timer.wait_time > 0. else 0.
	
	print_thingy()
