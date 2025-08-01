extends Area2D

var detectedBody

func _on_body_entered(body: Node2D) -> void:
	print("near enemy")
	detectedBody = body
	body.emit_signal("nearEnemy", get_parent())

func _on_body_exited(body: Node2D) -> void:
	if body == detectedBody:
		print("leaving enemy")
		body.emit_signal("leavingEnemy", get_parent())
