extends CharacterBody2D

@onready var rope := get_node("../Player/Rope")
@onready var colShape := get_node("CollisionShape2D")
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var minSegments = 12
@export var player: CharacterBody2D
@export var speed = 180

var radius: float



func _ready():
	var collision_shape = $Detector
	radius = collision_shape.shape.radius

func _physics_process(dt):
	check_points()
	navigation_agent.target_position = player.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	move_and_slide()

func check_points():
	var points = rope.get_points()
	var count = 0
	for point in points:
		if self.position.distance_to(point) < radius:
			count += 1
	if count >= minSegments:
		queue_free()

func is_point_within_circle(point: Vector2) -> bool:
	return self.position.distance_to(point) < radius
