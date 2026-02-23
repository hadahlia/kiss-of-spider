extends Control

func _ready() -> void:
	get_tree().create_timer(3.0).timeout.connect(_on_timeout)

func _on_timeout():
	hide()
