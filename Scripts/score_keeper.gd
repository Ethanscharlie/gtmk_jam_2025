extends Node2D


func _on_enemy_spawner_enemy_spawned(new_enemy: Variant) -> void:
	var detector = new_enemy.get_node("Detector")
	detector.enemy_killed.connect(_on_enemy_killed)

	
func _on_enemy_killed() -> void:
	print("Enemy Killed")
