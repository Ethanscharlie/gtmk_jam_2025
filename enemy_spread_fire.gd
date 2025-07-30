extends Node2D

@export var seconds_cooldown: float = 1.0
@export var count_of_bullets: int = 5

var bullet_scene = preload("res://bullet.tscn")

func _ready():
	_start_timer()

func _start_timer():
	while true:
		await get_tree().create_timer(1.0).timeout
		_fire_bullets_in_spread_pattern()
		
func _fire_bullets_in_spread_pattern():
	for i in range(count_of_bullets):
		_fire_bullet()
		_rotate_one_tick()

func _fire_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.rotation = rotation
	bullet.position = global_position
	get_tree().get_root().add_child(bullet)
	
func _rotate_one_tick():
	var tick_degrees = 360.0 / count_of_bullets
	rotate(deg_to_rad(tick_degrees))
