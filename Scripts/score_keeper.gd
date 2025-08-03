extends Node2D

signal score_updated(new_score: int)
signal enemy_killed

var score = 0

func _on_enemy_spawner_enemy_spawned(new_enemy: Variant) -> void:
	pass
	
func _on_enemy_killed() -> void:
	score += 100
	_update_score()

func _update_score() -> void:
	emit_signal("score_updated", score)

func _on_player_reset_wave() -> void:
	score -= 100
	_update_score()
