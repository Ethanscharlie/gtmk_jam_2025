extends Node2D

signal enemy_spawned(new_enemy)

@export var spawn_rate = 2

var basic_enemy = preload("res://Scenes/Entities/basic_enemy.tscn")

func _ready():
	_start_timer()
	
func _start_timer():
	while true:
		await get_tree().create_timer(spawn_rate).timeout
		spawn_enemies()
		
func spawn_enemies():
	var enemy = basic_enemy.instantiate()
	get_parent().get_parent().add_child(enemy)
	
	emit_signal("enemy_spawned", enemy)
	
