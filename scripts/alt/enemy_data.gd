extends VBoxContainer
class_name EnemyNode

signal deal_damage(power: int)

@onready var attack_delay: Timer = $attack_delay

@onready var icon: TextureRect = $HBoxContainer/icon
@onready var name_label: Label = $HBoxContainer/Name
@onready var stats: Label = $stats


@export var params: EnemyParams

var distance: float = 100.0


func _ready() -> void:
	if !params: print("no params!!!! [enemy version] AAAAAAAAAAAA"); return
	icon.texture = params.icon
	name_label.text = params.name
	update_labels()

func update_labels()->void:
	
	stats.text = "HP %d POW %d \n %01.0fm " % [params.health, params.power, distance]

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

func die()->void:
	queue_free()
