extends Resource
class_name AbilityParams

enum HitType {SINGLE, AOE}

@export_category("Ability Parameters")
@export var icon :Texture = preload("uid://bvn88ao6qm4v0")
@export var name: String = "move_name" ## Should be only one word
@export var power: int = 3 ## Amt of damage dealt
@export var cooldown_time: float = 5.0
@export var type: HitType
#@export_category("AoE-only")
@export var radius: float
