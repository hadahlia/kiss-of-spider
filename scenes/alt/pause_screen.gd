extends Control

func _ready() -> void:
	hide()

func _input(_event: InputEvent) -> void:
	if GameGlobals.newDawn: return
	if not GameGlobals.LevelScreen and not GameGlobals.GirlDead and Input.is_action_just_pressed("ui_cancel"):
		pause()


func pause()->void:
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused
	print("paused: ", get_tree().paused)
