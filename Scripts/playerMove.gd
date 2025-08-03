extends CharacterBody2D

@export var speed = 50
@export var turn_speed = 5
@export var drag = 5
@export var dash_speed = 2000
@export var dash_cooldown = 1

# Control scheme variables
# "wasd" or "mouse"
@export var mouse_sensitivity = 1.0
@export var mouse_deadzone = 10.0  # Minimum distance from player to move

var can_dash = true
var Sprite
var mouse_target_position = Vector2()
var animated_sprite

signal hit
signal reset_wave

func _ready():
	Sprite = $Player
	animated_sprite = $Player
	animated_sprite.play()  # Plays the default animation
	animated_sprite.play("move")
	show()
	
func _physics_process(delta):
	_add_input_to_velocity()
	_apply_velocity_drag(delta)
	move_and_slide()

func _input(event):
	if Input.is_action_pressed("dash") and can_dash:
		_dash()
	
	# Toggle control mode (you can bind this to any key you want)
	if Input.is_action_just_pressed("toggle_controls"):
		_toggle_control_mode()
	
	# Update mouse target position for mouse controls
	if Menu.control_mode == "mouse" and event is InputEventMouseMotion:
		mouse_target_position = get_global_mouse_position()

func _toggle_control_mode():
	if Menu.control_mode == "wasd":
		Menu.control_mode = "mouse"
		print("Switched to mouse controls")
	else:
		Menu.control_mode = "wasd"
		print("Switched to WASD controls")

func _dash():
	velocity = _get_input_direction_vector() * dash_speed
	_queue_dash_cooldown()

func _queue_dash_cooldown():
	can_dash = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _add_input_to_velocity():
	var input_vector = _get_input_direction_vector()
	velocity += input_vector * speed
	
	# Rotate sprite to face movement direction (for down-facing sprite)
	if input_vector.length() > 0:
		var target_rotation = input_vector.angle() + PI/2  # Offset for down-facing sprite
		Sprite.rotation = lerp_angle(Sprite.rotation, target_rotation, turn_speed * get_physics_process_delta_time())

func _get_input_direction_vector() -> Vector2:
	if Menu.control_mode == "wasd":
		return Input.get_vector("left", "right", "up", "down")
	else:
		return _get_mouse_direction_vector()

func _get_mouse_direction_vector() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position)
	
	# Only move if mouse is far enough away (deadzone)
	if direction.length() < mouse_deadzone:
		return Vector2.ZERO
	
	return direction.normalized() * mouse_sensitivity

func _apply_velocity_drag(delta):
	velocity = velocity.lerp(Vector2(), drag * delta)

func _on_hit() -> void:
	print("player hit")
	emit_signal("reset_wave")
