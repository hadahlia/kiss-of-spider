extends Container
class_name EnemyRoot

@onready var e: EnemyNode = $EnemyData
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.hide()
	e.died.connect(func()->void: texture_rect.show(); e.hide())
	
