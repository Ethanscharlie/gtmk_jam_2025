extends Label

var death_count

func _ready() -> void:
	death_count = 0


func _on_enemy_spawner_player_killed() -> void:
	print("add to death count")
	death_count += 1
	text = "DEATHS" + str(death_count)
