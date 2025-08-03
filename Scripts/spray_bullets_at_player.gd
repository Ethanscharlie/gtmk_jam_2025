extends Node2D
@export var seconds_cooldown: float = 3
@export var count_of_bullets: int = 3
@export var spray_angle_degrees: int = 30
@onready var sfx_enemyshoot: AudioStreamPlayer = $"../sfx/sfx_enemyshoot"

var bullet_scene = preload("res://Scenes/Entities/bullet.tscn")

func _ready():
	_start_timer()

func _start_timer():
	while true:
		await get_tree().create_timer(seconds_cooldown).timeout
		_fire_bullets_in_spread_pattern()
		
func _fire_bullets_in_spread_pattern():
	rotation = get_parent().rotation - 90
	rotate(deg_to_rad(spray_angle_degrees/2))
	for i in range(count_of_bullets):
		_fire_bullet()
		_rotate_one_tick()

func _fire_bullet():
	var bullet_1 = bullet_scene.instantiate()
	bullet_1.rotation = rotation
	bullet_1.position = global_position
	get_parent().get_parent().add_child(bullet_1)
	sfx_enemyshoot.play()
	
func _rotate_one_tick():
	var tick_degrees = spray_angle_degrees / count_of_bullets
	rotate(deg_to_rad(tick_degrees))
