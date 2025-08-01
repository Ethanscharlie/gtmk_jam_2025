extends Node2D

signal score_updated(new_score: int)
signal enemy_killed

var total_enemies_killed = 0
var score = 0

func _on_enemy_spawner_enemy_spawned(new_enemy: Variant) -> void:
	pass
	
func _on_enemy_killed() -> void:
	total_enemies_killed += 1
	_update_score()

func _update_score() -> void:
	score = total_enemies_killed * 100
	emit_signal("score_updated", score)

func _on_player_reset_wave() -> void:
	total_enemies_killed = 0
	_update_score()
