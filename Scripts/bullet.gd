extends CharacterBody2D

@export var speed: float = 200

func _physics_process(delta):
	velocity = transform.x * speed
	move_and_slide()
