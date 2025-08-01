extends Node2D

@export var seconds_cooldown: float = 3
@export var count_of_bullets: int = 3

var bullet_scene = preload("res://Scenes/Entities/bullet.tscn")

func _ready():
	_start_timer()

func _start_timer():
	while true:
		await get_tree().create_timer(seconds_cooldown).timeout
		_fire_bullets_in_spread_pattern()
		
func _fire_bullets_in_spread_pattern():
	rotation = 0
	for i in range(count_of_bullets):
		_fire_bullet()
		_rotate_one_tick()

func _fire_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.rotation = rotation
	bullet.position = global_position
	get_parent().get_parent().add_child(bullet) #changed from root so referencing player from bullet is easier
	
func _rotate_one_tick():
	var tick_degrees = 360.0 / count_of_bullets
	rotate(deg_to_rad(tick_degrees))
