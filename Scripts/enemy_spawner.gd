extends Node2D

signal enemy_spawned(new_enemy)
signal enemy_killed
signal new_wave(wave: int)

@export var spawn_rate = 2
@export var spawn_margin = 30
var SCREEN_WIDTH = 1920
var SCREEN_HEIGHT = 1080

var current_wave = -1
var current_enemies_in_wave = 0
var wave_data = [
	3,
	4,
	5
]

var basic_enemy = preload("res://Scenes/Entities/basic_enemy.tscn")
var credits = preload("res://Scenes/Entities/Credits.tscn")

func _ready():
	_next_wave()
	
func _next_wave():
	if current_wave == len(wave_data) - 1:
		_open_credits()
		_destroy_all_enemies_and_bullets()
		return
	
	current_wave += 1
	current_enemies_in_wave = wave_data[current_wave]
	_spawn_in_enemies(current_enemies_in_wave)
	emit_signal("new_wave", current_wave)
	
func _spawn_in_enemies(count: int) -> void:
	for i in count: spawn_enemy()
	
func _get_random_spawn_position() -> Vector2:
	var picked_position = Vector2(0, 0)
	
	match ["north", "south", "east", "west"].pick_random():
		"north":
			picked_position.x = SCREEN_WIDTH * randf()
			picked_position.y = -spawn_margin
		"south":
			picked_position.x = SCREEN_WIDTH * randf()
			picked_position.y = SCREEN_HEIGHT + spawn_margin
		"east":
			picked_position.x = SCREEN_WIDTH + spawn_margin
			picked_position.y = SCREEN_HEIGHT * randf()
		"west":
			picked_position.x = -spawn_margin
			picked_position.y = SCREEN_HEIGHT * randf()
	
	return picked_position
	
func spawn_enemy():
	var enemy = basic_enemy.instantiate()
	enemy.position = _get_random_spawn_position()
	get_parent().get_parent().add_child.call_deferred(enemy)
	
	emit_signal("enemy_spawned", enemy)

func _on_enemy_killed() -> void:
	current_enemies_in_wave -= 1
	if current_enemies_in_wave <= 0: _next_wave()
	
func _destroy_all_enemies_and_bullets():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for bullet in get_tree().get_nodes_in_group("bullets"):
		print("destroy bullets")
		bullet.queue_free()
	
func _reset_players_position() -> void:
	var player = get_node("../../Player")
	player.position = Vector2(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)

func _on_player_reset_wave() -> void:
	_reset_players_position()
	_destroy_all_enemies_and_bullets()
	current_wave -= 1
	_next_wave()
	
func _open_credits() -> void:
	var credits_instance = credits.instantiate()
	get_tree().get_root().add_child.call_deferred(credits_instance)
