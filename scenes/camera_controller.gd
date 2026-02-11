extends Node3D

@export var camera: Camera3D

@export var player: CharacterBody3D

const OFFSET_X: float = 60.0
const OFFSET_Y: float = 50.0
const CAMSPEED : float = 3.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	self.global_position = player.global_position
	
	var goalpos = Vector3(self.global_position.x + OFFSET_X, self.global_position.y + OFFSET_Y, self.global_position.z + OFFSET_X)
	
	camera.global_position.x = lerp(camera.global_position.x, goalpos.x, CAMSPEED * delta)
	camera.global_position.y = lerp(camera.global_position.y, goalpos.y, CAMSPEED * delta)
	camera.global_position.z = lerp(camera.global_position.z, goalpos.z, CAMSPEED * delta)
	
	
