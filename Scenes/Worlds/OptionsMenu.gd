extends Node
var animation_player

func _ready() -> void:
	animation_player = $AnimationPlayer
	
	animation_player.play("Startup")

func _on_back_pressed() -> void:
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/main_game.tscn")
