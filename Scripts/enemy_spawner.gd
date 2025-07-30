extends Node2D
@export var basic_enemy: PackedScene

func _ready():
	_start_timer()
	
func _start_timer():
	while true:
		await get_tree().create_timer(2).timeout
		spawn_enemies()
		
func spawn_enemies():
	var enemy = basic_enemy.instantiate()
	get_parent().add_child(enemy)
	
