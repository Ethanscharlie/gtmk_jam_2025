extends Node
var animation_player
@onready var sfx_mouseover: AudioStreamPlayer = $sfx_mouseover

func _ready() -> void:
	animation_player = $AnimationPlayer
	
	animation_player.play("Startup")

		#animation_player.play("Fade")
		#Menu.Main = true


func _on_play_pressed() -> void:
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/main_game.tscn")

func _on_options_pressed() -> void:
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/OptionsMenu.tscn")


func _on_play_mouse_entered() -> void:
	sfx_mouseover.play()
	

func _on_options_mouse_entered() -> void:
	sfx_mouseover.play()
