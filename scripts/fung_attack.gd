extends Node3D
class_name FungalAttack

@onready var atk_time: Timer = $atk_time

func _ready() -> void:
	atk_time.timeout.connect(_on_atk_timeout)


func _on_atk_timeout()->void:
	self.queue_free()
