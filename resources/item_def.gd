extends Resource
class_name ItemParams

enum ItemType {NONE, AOE, DIAGONALC, STRAIGHTC, RANDOM}

@export_category("Item Parameters")
@export var icon: Texture
@export var name: String
@export var desc: String
@export var item_type: ItemType = ItemType.NONE

@export var radius: float = 0.0 ##Only applies to AOE item types
