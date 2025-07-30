extends Node2D

@onready var rope := get_node("..")

func _physics_process(dt):
	print(rope.get_points())
	
