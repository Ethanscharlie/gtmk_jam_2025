extends Node2D
@onready var rope = get_node("../Rope")

func _ready():
	_start_timer()
	randomize()

func _start_timer():
	global_position = rope.get_point_interpolate(randf())
		
