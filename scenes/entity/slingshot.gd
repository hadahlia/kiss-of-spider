extends Node3D

@onready var trigger_1: Area3D = $trigger1
@onready var trigger_2: Area3D = $trigger2

@onready var mark_1: Marker3D = $mark1
@onready var mark_2: Marker3D = $mark2


# the idea here is you trigger either one side or other side, but regardless you latch both arms onto the marker points
# from there, slingshot tension logic?
