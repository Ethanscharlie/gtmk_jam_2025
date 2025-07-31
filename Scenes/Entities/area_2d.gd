extends Area2D

@onready var rope = get_node("../Rope")
@export var loop_tolerance = 11

var polygonPoints:PackedVector2Array

func _physics_process(dt):
	var points = rope.get_points()
	
	var close_points = find_close_points(points)
	polygonPoints.clear()
	if close_points != []:
		var point_1 = rope.get_nearest_point_index(close_points.get(0))
		var point_2 = rope.get_nearest_point_index(close_points.get(1))
		for i in range(point_1,point_2 + 1):
			polygonPoints.append($CollisionPolygon2D.to_local(rope.get_point(i)))
		print("polygon made")
	$CollisionPolygon2D.polygon = polygonPoints
	$Polygon2D.polygon = polygonPoints
	await get_tree().create_timer(0.2).timeout
	
func find_close_points(points: PackedVector2Array) -> Array:
	for i in range(points.size()):
		for j in range(i + 1, points.size()):
			if points[i].distance_to(points[j]) < loop_tolerance:
				return [points[i], points[j]]
	return []

func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
