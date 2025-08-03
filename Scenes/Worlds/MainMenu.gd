extends Node
var animation_player
@onready var sfx_play: AudioStreamPlayer = $sfx_play
@onready var sfx_mouseover: AudioStreamPlayer = $sfx_mouseover

func _ready() -> void:
	animation_player = $AnimationPlayer
	
	animation_player.play("Intro")

		#animation_player.play("Fade")
		#Menu.Main = true


func _on_play_pressed() -> void:
	sfx_play.play()
	animation_player.play("PlayButton")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	var new_color = Color8(0, 0.314, 0.314)
	tween.tween_property($Sprite2D, "modulate", new_color, 1)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Worlds/main_game.tscn")

func _on_options_pressed() -> void:
	animation_player.play("Options")
	Menu.Main = false
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/OptionsMenu.tscn")
	print("OptionSwitch")

func _on_play_mouse_entered() -> void:
	sfx_mouseover.play()

func _on_options_mouse_entered() -> void:
	sfx_mouseover.play()
