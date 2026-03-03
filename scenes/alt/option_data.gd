extends VBoxContainer
class_name OptionData

#@onready var num: Label = $num
@onready var info: Label = $info
#@onready var icon: TextureRect = $icon
@onready var icon: TextureRect = $HBoxContainer/icon

func set_num(num: String)->void:
	$HBoxContainer/num.text = num

func set_item(param: Resource)->void:
	if param is AbilityParams:
		icon.texture = param.icon
		info.text = "%s\n\n%d\n%0.2f\n\n%s" % [param.name, param.power, param.cooldown_time, param.HitType.keys()[param.type] ]
		#return
	elif param is ItemParams:
		icon.texture = param.icon
		info.text = "%s\n\n%s\n\n%s" % [param.name, param.desc, param.ItemType.keys()[param.item_type] ]
