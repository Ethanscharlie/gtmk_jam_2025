extends Label

func _ready() -> void:
	text = "SCORE: " + str(0)

func _on_scorekeeper_score_updated(new_score: int) -> void:
	text = "SCORE: " + str(new_score)
