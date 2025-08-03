extends Label
var waves
var deaths

func _ready() -> void:
	waves = 1
	deaths = 0
	text = " WAVE: 1 \n\n\n DEATHS: 0"
	
	
func _on_enemy_spawner_new_wave(waves: int) -> void:
	waves = waves + 1
	text = " WAVE: " + str(waves) + "\n\n\n DEATHS: " + str(deaths)
	
func _on_enemy_spawner_player_killed() -> void:
	deaths += 1
	text = " WAVE: " + str(waves) + "\n\n\n DEATHS: " + str(deaths)
