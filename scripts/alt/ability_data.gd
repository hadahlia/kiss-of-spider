extends VBoxContainer
class_name AbilityNode

@onready var move_icon: TextureRect = $HBoxContainer/move_icon
@onready var ability_name: Label = $HBoxContainer/ability_name
@onready var ability_info: Label = $ability_info

@export var params: AbilityParams

@onready var timer: Timer = $Timer
@onready var ability_cooldown: ProgressBar = $HBoxContainer/ability_name/ability_cooldown

func _ready() -> void:
	if !params: print("no params!!!! welp"); return
	move_icon.texture = params.icon
	ability_name.text = params.name
	ability_info.text = "POW %d\t t %2.1fs\n%s %2.1fm" % [params.power, params.cooldown_time, params.HitType.keys()[params.type], params.radius]
	
	timer.wait_time = params.cooldown_time
	ability_cooldown.max_value = timer.wait_time
	ability_cooldown.value = 0

func _process(delta: float) -> void:
	ability_cooldown.value = timer.time_left
