extends CharacterBody3D



@export_category("Params")
enum Types {FRIENDLY, ENEMYMELEE, ENEMYPROJECTILE}
@export var type: Types

@export var turn_speed: float = 1.0
@export var move_speed: float = 5.0

func _ready() -> void:
	match type:
		Types.FRIENDLY:
			var bubble = AssetsList.THOUGHT_SCENE.instantiate()
			
			add_child(bubble)
			bubble.position.y = 5.0
		Types.ENEMYMELEE:
			pass
		Types.ENEMYPROJECTILE:
			pass

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match type:
		Types.FRIENDLY:
			pass
		Types.ENEMYMELEE:
			pass
		Types.ENEMYPROJECTILE:
			pass
	
	
	move_and_slide()
	
