extends Node3D

@onready var redoll_2_rigged: Node3D = $redoll_2_rigged

@export var spin_speed: float = 1.1

func _physics_process(delta: float) -> void:
	
	redoll_2_rigged.rotate_x(delta * spin_speed)
	redoll_2_rigged.rotate_y(delta * (spin_speed/2))
