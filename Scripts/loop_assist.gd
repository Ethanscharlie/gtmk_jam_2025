extends Node2D

signal nearEnemy(Node2D)
signal leavingEnemy(Node2D)
@onready var rope = get_parent()
var current_enemy: Node2D

func _physics_process(delta):
	try_and_loop()

func try_and_loop():
	if current_enemy != null:
		var rope_End = rope.get_point_interpolate(1)
		rope.gravity_direction = current_enemy.position.direction_to(rope_End)

func _on_near_enemy(enemy: Variant) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(rope, "gravity", 30, 1.0).set_trans(Tween.TRANS_CIRC)
	
	if current_enemy == null:
		current_enemy = enemy
		
func _on_leaving_enemy(enemy: Variant) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	if enemy == current_enemy:
		rope.gravity_direction = Vector2.ZERO
		tween.tween_property(rope, "gravity", 0, 0.5).set_trans(Tween.TRANS_CIRC)
		current_enemy = null
