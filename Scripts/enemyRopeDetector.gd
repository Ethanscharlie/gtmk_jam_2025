extends CollisionShape2D

signal enemy_killed()

@onready var rope = get_node("../../Player/Rope")

@export var minSegments = 12

func _physics_process(dt):
	var points = rope.get_points()
	
	var count = 0
	for point in points:
		if is_point_within_circle(point):
			count += 1
			
	if count >= minSegments:
		emit_signal("enemy_killed")
		get_parent().queue_free()

func is_point_within_circle(point: Vector2) -> bool:
	
	return self.global_position.distance_to(point) < shape.radius
