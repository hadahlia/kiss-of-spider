extends VBoxContainer
class_name EnemyNode

signal deal_damage(power: int)

signal died

const MAX_DISTANCE: float = 19898.0

@onready var attack_delay: Timer = $attack_delay



@onready var icon: TextureRect = $HBoxContainer/icon
@onready var name_label: Label = $HBoxContainer/Name
@onready var stats: Label = $stats
@onready var distance_tag: Label = $distance_tag


@export var params: EnemyParams

@export var distance_col: Gradient

var distance: float = 100.0
var start_distance: float
var is_dead: bool = false

func _ready() -> void:
	set_params()

func set_params()->void:
	if !params: print("no params!!!! [enemy version] AAAAAAAAAAAA"); return
	icon.texture = params.icon
	name_label.text = params.name
	update_labels()
	distance = params.starting_dist + randf_range(-9, 9)
	
	start_distance = distance
	params = params.duplicate()
	
	$TextureRect.hide()
	$HBoxContainer.show()
	stats.show()
	distance_tag.show()

func sample_color()->Color:
	var offset: float = (distance / start_distance) if distance > 0. else 0.
	
	return distance_col.sample(offset)


func update_labels()->void:
	
	stats.text = "HP %d PWR %d" % [params.health, params.power ]
	distance_tag.text = "%01.0fm" % distance
	distance_tag.add_theme_color_override("font_color", sample_color())

func _process(delta: float) -> void:
	if distance < 0:
		distance = 0
	
	if distance > 0:
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
	set_params()
	set_process(true)

func die()->void:
	died.emit()
	$TextureRect.show()
	$HBoxContainer.hide()
	stats.hide()
	distance_tag.hide()
	is_dead = true
	set_process(false)
	#queue_free()
