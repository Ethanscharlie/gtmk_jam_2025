extends Area2D

@onready var rope = get_node("../Rope")
@onready var loopAssist = get_parent().get_node("Rope/loopAssist")
@export var loop_tolerance = 11

func _physics_process(dt):
	var close_points = find_close_points()
	if close_points == []: return
	
	var point_1 = close_points.get(0)
	var point_2 = close_points.get(1)
	
	var loop_size = _get_loop_size_from_point_indexes(point_1, point_2)
	var loop_size_is_large_enough = loop_size >= 3
	if not loop_size_is_large_enough:
		_set_polygon_to_nothing()
		return
	
	var polygonPoints = _build_polygon_points_from_rope_segment_indexes(point_1, point_2)
	_set_polygon_to_points_list(polygonPoints)
	
func _set_polygon_to_points_list(points_list: PackedVector2Array) -> void:
	$CollisionPolygon2D.polygon = points_list
	$Polygon2D.polygon = points_list

func _build_polygon_points_from_rope_segment_indexes(point_a_index: int, point_b_index: int) -> PackedVector2Array:
	var polygonPoints = []
	
	var sorted_index_array = get_lesser_and_larger_index(point_a_index, point_b_index)
	var point_with_lesser_index = sorted_index_array[0]
	var point_with_larger_index = sorted_index_array[1]
	for i in range(point_with_lesser_index, point_with_larger_index + 1):
		polygonPoints.append($CollisionPolygon2D.to_local(rope.get_point(i)))
		
	return polygonPoints
	
func get_lesser_and_larger_index(index_a: int, index_b: int) -> Array:
	if index_a < index_b: return [index_a, index_b]
	else: return [index_b, index_a]
	
func _set_polygon_to_nothing():
	$CollisionPolygon2D.polygon = PackedVector2Array()
	$Polygon2D.polygon = PackedVector2Array()
	
func find_close_points() -> Array:
	var points = rope.get_points()
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
