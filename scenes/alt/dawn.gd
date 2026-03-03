extends Control

# intro script

#
#func _on_video_stream_player_finished() -> void:
	##get_tree().change_scene_to_file("res://scenes/alt/girlspace.tscn")
	#
func _ready() -> void:
	GameGlobals.newDawn = true
	get_tree().paused = false

func _gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		load_space()
	if event is InputEventMouseButton:
		print("happen")
		if event.pressed and event.button_index:
			load_space()

func _on_video_stream_player_finished() -> void:
	#get_tree().r
	
	load_space()
	

func load_space()->void:
	GameGlobals.d_time = 0
	#var d_time: float

	#const D_FACTOR: float = 1.1
	#GameGlobals.GirlLevel 
	#var GirlLevel: int
	GameGlobals.GirlDead = false
	#var GirlDead: bool = false
	GameGlobals.LevelScreen = false
	#var LevelScreen: bool = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/alt/girlspace.tscn")
	#get_tree().change_scene_to_file("res://scenes/alt/girlspace.tscn")
	
	GameGlobals.newDawn = false
