extends Node2D
	
var animation_player

func _ready() -> void:
	animation_player = $AnimationPlayer
	
	animation_player.play("startup")
