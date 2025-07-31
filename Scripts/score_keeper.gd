extends Node2D

signal score_updated(new_score: int)

var total_enemies_killed = 0
var score = 0

func _on_enemy_spawner_enemy_spawned(new_enemy: Variant) -> void:
	var detector = new_enemy.get_node("Detector")
	detector.enemy_killed.connect(_on_enemy_killed)
	
func _on_enemy_killed() -> void:
	total_enemies_killed += 1
	_update_score()

func _update_score() -> void:
	score = total_enemies_killed
	emit_signal("score_updated", score)
