extends CharacterBody2D

@export var speed = 50
@export var turn_speed = 5
@export var drag = 5

@export var dash_speed = 2000
@export var dash_cooldown = 1
var can_dash = true


signal hit
signal reset_wave


func _ready():
	show()

func _physics_process(delta):
	_add_input_to_velocity()
	_apply_velocity_drag(delta)
		
	move_and_slide()

func _input(event):
	if Input.is_action_pressed("dash") and can_dash:
		_dash()
		
func _dash():
	velocity = _get_input_direction_vector() * dash_speed
	_queue_dash_cooldown()

func _queue_dash_cooldown():
	can_dash = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	
func _add_input_to_velocity():
	velocity += _get_input_direction_vector() * speed
	
func _get_input_direction_vector() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func _apply_velocity_drag(delta):
	velocity = velocity.lerp(Vector2(), drag * delta)

func _on_hit() -> void:
	emit_signal("reset_wave")
