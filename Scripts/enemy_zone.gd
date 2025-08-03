extends Path2D
@onready var player = get_node("../Player")
@onready var area: Area2D = $Area2D
@onready var path_follow_node: PackedScene = preload("res://Scenes/Entities/path_follow_2d.tscn")
@export var snap_duration := 0.5

signal snap_enemy_to_path(Node2D)

func _process(delta: float) -> void:
	for pf in get_children():
		if pf is PathFollow2D:
			var target_progress = find_closest_progress_to_point(self as Path2D, player.global_position)
			var speed = 100.0
			var direction = sign(target_progress - pf.progress)
			pf.progress += direction * speed * delta
			#pf.progress = lerp(pf.progress, target_progress, 2 * delta)
			

func find_closest_progress_to_point(path: Path2D, target_position: Vector2, sample_count: int = 100) -> float:
	var closest_distance := INF
	var closest_progress := 0.0
	var curve := path.curve
	var total_length := curve.get_baked_length()
	for i in sample_count:
		var t := i / float(sample_count)
		var progress := t * total_length
		var point := curve.sample_baked(progress)
		var dist := point.distance_to(target_position)
		if dist < closest_distance:
			closest_distance = dist
			closest_progress = progress
	return closest_progress
	
func _on_snap_enemy_to_path(enemy: Variant) -> void:
	print("moving enemy to path")
	var pf = path_follow_node.instantiate()
	add_child(pf)
	pf.progress = find_closest_progress_to_point(self as Path2D, player.global_position)

	var tween := get_tree().create_tween()
	tween.tween_property(enemy, "global_position", pf.global_position, snap_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", func():
		var g_transform = enemy.global_transform
		enemy.get_parent().remove_child(enemy)
		pf.add_child(enemy)
		enemy.position = Vector2.ZERO
		enemy.global_transform = g_transform
	)


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.emit_signal("snap_to_path", self)
	print("enemy in path area")
