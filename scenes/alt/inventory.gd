extends Node


var items_dictionary: Dictionary = {
	#"1"
}

var item_array : Array[EffectItem]

func _ready() -> void:
	var items :Array[Node] = get_children() 
	
	for i in items:
		if i is EffectItem:
			item_array.append(i)
	
	#activate item cooldowns? on timeout, activate that one?
