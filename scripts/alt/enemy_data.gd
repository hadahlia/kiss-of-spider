extends VBoxContainer
class_name EnemyNode

signal deal_damage(power: int)

signal died

@onready var attack_delay: Timer = $attack_delay

@onready var icon: TextureRect = $HBoxContainer/icon
@onready var name_label: Label = $HBoxContainer/Name
@onready var stats: Label = $stats


@export var params: EnemyParams

var distance: float = 100.0
var is_dead: bool = false

func _ready() -> void:
	if !params: print("no params!!!! [enemy version] AAAAAAAAAAAA"); return
	icon.texture = params.icon
	name_label.text = params.name
	update_labels()
	distance = params.starting_dist + randf_range(-9, 9)
	params = params.duplicate()
	
	$TextureRect.hide()
	$HBoxContainer.show()
	stats.show()

func update_labels()->void:
	
	stats.text = "HP%d POW%d \n %01.0fm " % [params.health, params.power, distance]

func _process(delta: float) -> void:
	if distance > 0.1:
		distance -= delta * params.speed
		
	else:
		if attack_delay.is_stopped():
			deal_damage.emit(params.power)
			attack_delay.start()
	update_labels()

func take_damage(dmg:int)->void:
	params.health -= dmg
	if params.health <= 0:
		params.health = 0
		die()

func reset(new_params: EnemyParams)->void:
	$TextureRect.hide()
	$HBoxContainer.show()
	stats.show()
	is_dead = false
	params = new_params.duplicate()
	set_process(true)

func die()->void:
	died.emit()
	$TextureRect.show()
	$HBoxContainer.hide()
	stats.hide()
	is_dead = true
	set_process(false)
	#queue_free()
