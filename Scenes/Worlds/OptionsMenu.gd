extends Node
var animation_player

func _ready() -> void:
	animation_player = $AnimationPlayer
	animation_player.play("Intro")

func _on_back_pressed() -> void:
	animation_player.play("Options")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/MainMenu.tscn")
	print("MenuSwitch")
