extends MeshInstance3D

func _ready() -> void:
	call_deferred("reparent", get_parent().get_parent(), true)
	#reparent()

func _process(delta: float) -> void:
	global_position = GameGlobals.cursor_pos_3d
