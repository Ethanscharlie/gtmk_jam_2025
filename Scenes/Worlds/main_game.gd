extends Node2D

func _ready() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	$background.modulate = Color8(0,0,0)
	var new_color = Color8(0, 80, 80, 225)
	tween.tween_property($background, "modulate", new_color, 1)
