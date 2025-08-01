extends Area2D

signal kill_enemy

func _on_body_entered(body: Node2D) -> void:
	print("near enemy")
	body.get_node("Rope/loopAssist").emit_signal("nearEnemy", get_parent())

func _on_body_exited(body: Node2D) -> void:
	print("leaving enemy")
	body.get_node("Rope/loopAssist").emit_signal("leavingEnemy", get_parent())

func _on_kill_enemy() -> void:
	if not get_parent().is_alive:
		return 
		
	get_parent().is_alive = false
	get_node("../../game_manager/EnemySpawner").emit_signal("enemy_killed")
	get_node("../../game_manager/Scorekeeper").emit_signal("enemy_killed")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(get_parent(), "scale", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(get_parent().queue_free)
