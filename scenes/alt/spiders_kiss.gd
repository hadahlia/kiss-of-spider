extends Control
class_name SpidersKiss

#@onready var h_box_container: HBoxContainer = $PanelContainer/HBoxContainer
#@onready var option_box: HBoxContainer = $PanelContainer/OptionBox
@onready var option_box: HBoxContainer = $PanelContainer/MarginContainer/OptionBox



func _ready() -> void:
	visible = false

func _toggle_screen()->void:
	visible = !visible
	
	get_tree().paused = visible
	
	GameGlobals.LevelScreen = visible

func set_items()->void:
	var options : Array[Node] = option_box.get_children()
	var i: int = 1
	for o in options:
		#pass
		match i:
			1:
				o.set_num("1.")
				o.set_item(AssetsList.PARAMS_ITEM_HEART)
			2:
				o.set_num("2.")
				o.set_item(AssetsList.PARAMS_ITEM_SPORE)
			3:
				o.set_num("3.")
				o.set_item(AssetsList.PARAMS_ABILITY_HOG)
		i += 1
	
	# return an array to the dictionary, for query reply?
