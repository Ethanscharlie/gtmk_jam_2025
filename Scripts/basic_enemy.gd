extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player:= get_node("../Player")
@export var speed = 180

func _physics_process(dt):
	
	navigation_agent.target_position = player.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	move_and_slide()
