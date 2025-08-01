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
	var loop_size = 0
	var point_pair = []
	for i in range(points.size()):
		for j in range(i + 1, points.size()):
			var dist = points[i].distance_to(points[j])
			if dist < loop_tolerance and abs(j-i) > loop_size:
				loop_size = abs(j-i)
				point_pair = [i,j]
	return point_pair

func _on_body_entered(body: Node2D) -> void:
	if Geometry2D.is_point_in_polygon($CollisionPolygon2D.to_local(body.position), $CollisionPolygon2D.polygon):
		loopAssist.emit_signal("leavingEnemy",body)
		print("loopChecker triggered")
		body.get_node("ropeDetector").emit_signal("kill_enemy")
