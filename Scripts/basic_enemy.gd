extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player:= get_node("../Player")

@export var speed = 180

var is_alive = true

func _ready() -> void:
	set_physics_process(false)
	call_deferred("wait_for_physics")

func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(dt):
	navigation_agent.target_position = player.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	look_at(player.global_position)
	rotation += 90
	move_and_slide()
