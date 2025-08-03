extends Node2D
@onready var rope = get_parent()
var particle = preload("res://Scenes/Entities/cpu_particles_2d.tscn")
var particles := []

func _ready() -> void:
	var point_count = rope.get_num_points()
	for i in point_count:
		var instance = particle.instantiate()
		add_child(instance)
		instance.global_position = rope.get_point(i)
		particles.append(instance)

func _process(delta: float) -> void:
	for i in particles.size():
		var point_pos = rope.get_point(i)
		particles[i].global_position = point_pos
		
		
