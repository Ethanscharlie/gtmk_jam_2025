extends Label

var display_score = 0
var score = 0

@export var clock_speed: float = 0.001

func _ready() -> void:
	text = "SCORE: 0"
	_start_display_updater_clock()
	
func _start_display_updater_clock():
	while true:
		await get_tree().create_timer(clock_speed).timeout
		text = "SCORE: " + str(display_score)
		_increase_display_score_until_at_score()
			
func _increase_display_score_until_at_score():
	if display_score >= score:
		display_score = score
		return
	
	display_score += 1

func _on_scorekeeper_score_updated(new_score: int) -> void:
	score = new_score
