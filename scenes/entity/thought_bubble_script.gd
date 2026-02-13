extends Sprite3D

var frequency: float = 2.0
var amplitude: float = 20.0

var pos_offset: float

func _ready() -> void:
	pos_offset = global_position.y

func _physics_process(delta: float) -> void:
	pass
	#doesnt work yet
	#global_position.y = sin(delta*frequency)*amplitude + pos_offset
	#pass
