extends CharacterBody2D

@export var speed = 400
@export var turn_speed = 5

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		rotation += turn_speed * delta

	if Input.is_action_pressed("left"):
		rotation -= turn_speed * delta

	var direction = Vector2(1, 0).rotated(rotation)  # Rotate (1, 0) by the current rotation
	velocity = direction * speed
	move_and_slide()
