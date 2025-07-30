extends Node
var animation_player

func _ready() -> void:
	animation_player = $AnimationPlayer
	animation_player.play("Intro")
func _on_start_pressed() -> void:
		get_tree().change_scene_to_file("res://")


func _on_exit_pressed() -> void:
	get_tree().quit()
		
