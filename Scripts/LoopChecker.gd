extends Area2D

@onready var rope = get_node("../Rope")
@onready var loopAssist = get_parent().get_node("Rope/loopAssist")
@export var loop_tolerance = 11

var polygonPoints:PackedVector2Array

func _physics_process(dt):
	var points = rope.get_points()
	var close_points = find_close_points(points)
	polygonPoints.clear()
	if close_points != []:
		var point_1 = close_points.get(0)
		var point_2 = close_points.get(1)
		if point_1 > point_2:
			var temp = point_1
			point_1 = point_2
			point_2 = temp
		if abs(point_2 - point_1) >= 3:
			for i in range(point_1,point_2 + 1):
				polygonPoints.append($CollisionPolygon2D.to_local(rope.get_point(i)))
			$CollisionPolygon2D.polygon = polygonPoints
			$Polygon2D.polygon = polygonPoints
		else:
			$CollisionPolygon2D.polygon = PackedVector2Array()
			$Polygon2D.polygon = PackedVector2Array()
			
func find_close_points(points: PackedVector2Array) -> Array:
	var largest_loop_size = 0
	var point_pair = []
	
	for i in range(points.size()):
		var point_a = points[i]
		
		for j in range(i + 1, points.size()):
			var point_b = points[j]
			
			var current_loop_size = _get_loop_size_from_point_indexes(i, j)
			var loop_size_is_larger_than_previous_pick = current_loop_size > largest_loop_size
			if not loop_size_is_larger_than_previous_pick: continue
				
			if not _points_are_close_enough(point_a, point_b): continue
				
			largest_loop_size = current_loop_size
			point_pair = [i, j]
				
	return point_pair

func _get_loop_size_from_point_indexes(point_a_index: int, point_b_index: int) -> int:
	return abs(point_a_index - point_b_index)
	
func _points_are_close_enough(point_a: Vector2, point_b: Vector2) -> bool:
	var distance_between_points = point_a.distance_to(point_b)
	return distance_between_points < loop_tolerance

func _on_body_entered(body: Node2D) -> void:
	if Geometry2D.is_point_in_polygon($CollisionPolygon2D.to_local(body.position), $CollisionPolygon2D.polygon):
		loopAssist.emit_signal("leavingEnemy",body)
		body.get_node("ropeDetector").emit_signal("kill_enemy")
