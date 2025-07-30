extends CharacterBody2D

@onready var rope := get_node("../Player/Rope")
@onready var colShape := get_node("CollisionShape2D")

@export var minSegments = 12

var radius: float

func _ready():
	var collision_shape = $Detector
	radius = collision_shape.shape.radius

func _physics_process(dt):
	var points = rope.get_points()
	
	var count = 0
	for point in points:
		if is_point_within_circle(point):
			count += 1
	
	if count >= minSegments:
		queue_free()
	
func is_point_within_circle(point: Vector2) -> bool:
	return self.position.distance_to(point) < radius
