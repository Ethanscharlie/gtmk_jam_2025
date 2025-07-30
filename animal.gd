extends CharacterBody2D
@export var move_speed: float = 40.0
@export var move_time_range = Vector2(1.0, 2.0) # seconds
@export var wait_time_range = Vector2(0.5, 1.5) # seconds
@export var margin = 16

var direction = Vector2.ZERO
var is_moving = false
var timer = 0.0
var screen_size = Vector2.ZERO


func _ready():
	screen_size = get_viewport_rect().size
	_set_new_behavior()

func _physics_process(delta):
	timer -= delta

	if timer <= 0:
		_set_new_behavior()

	if is_moving:
		velocity = direction * move_speed
		move_and_slide()
		position.x = clamp(position.x, margin, screen_size.x - margin)
		position.y = clamp(position.y, margin, screen_size.y - margin)
	else:
		velocity = Vector2.ZERO
	
	

func _set_new_behavior():
	is_moving = randi() % 2 == 0

	if is_moving:
		direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		timer = randf_range(move_time_range.x, move_time_range.y)
	else:
		direction = Vector2.ZERO
		timer = randf_range(wait_time_range.x, wait_time_range.y)
