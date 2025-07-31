extends Node2D

signal enemy_spawned(new_enemy)

@export var spawn_rate = 2
@export var spawn_margin = 30
var SCREEN_WIDTH = 1920
var SCREEN_HEIGHT = 1080

var basic_enemy = preload("res://Scenes/Entities/basic_enemy.tscn")

func _ready():
	_start_timer()
	
func _start_timer():
	while true:
		await get_tree().create_timer(spawn_rate).timeout
		spawn_enemy()
		
func _get_random_spawn_position() -> Vector2:
	var picked_position = Vector2(0, 0)
	
	match ["north", "south", "east", "width"].pick_random():
		"north":
			picked_position.x = SCREEN_WIDTH * randf()
			picked_position.y = -spawn_margin
		"south":
			picked_position.x = SCREEN_WIDTH * randf()
			picked_position.y = SCREEN_HEIGHT + spawn_margin
		"east":
			picked_position.x = SCREEN_WIDTH + spawn_margin
			picked_position.y = SCREEN_HEIGHT * randf()
		"width":
			picked_position.x = -spawn_margin
			picked_position.y = SCREEN_HEIGHT * randf()
	
	return picked_position
	
func spawn_enemy():
	var enemy = basic_enemy.instantiate()
	enemy.position = _get_random_spawn_position()
	get_parent().get_parent().add_child(enemy)
	
	emit_signal("enemy_spawned", enemy)
	
