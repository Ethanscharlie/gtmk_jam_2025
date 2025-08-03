extends Label

func _ready() -> void:
	text = "WAVE: 1"
	
func _on_enemy_spawner_new_wave(wave: int) -> void:
	text = "WAVE: " + str(wave + 1)
