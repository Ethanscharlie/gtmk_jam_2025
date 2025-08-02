extends Node
var animation_player

func _ready() -> void:
	animation_player = $AnimationPlayer
	if Menu.Main == true:
		animation_player.play("Intro")
	else:
		animation_player.play("Fade")
		Menu.Main = true


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/main_game.tscn")

func _on_options_pressed() -> void:
	animation_player.play("Options")
	Menu.Main = false
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/OptionsMenu.tscn")
	print("OptionSwitch")
