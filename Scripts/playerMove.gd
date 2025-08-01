extends CharacterBody2D

@export var speed = 50
@export var max_speed = 500
@export var turn_speed = 5
@export var drag = 5

signal hit

func _ready():
	show()

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity += input_direction * speed
		
	velocity = velocity.lerp(Vector2(), drag * delta)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
		
	move_and_slide()
	
func _on_hit() -> void:
	print("player hit")
	get_tree().paused = true
	hide()
