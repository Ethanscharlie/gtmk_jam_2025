extends CharacterBody2D

@export var speed = 50
@export var max_speed = 500
@export var turn_speed = 5
@export var drag = 5
var current_enemy: Node2D

signal hit
signal nearEnemy(Node2D)
signal leavingEnemy(Node2D)
signal loopEnemy(Node2D)

func _ready():
	show()


func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity += input_direction * speed
		
	velocity = velocity.lerp(Vector2(), drag * delta)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
		
	move_and_slide()
	try_and_loop()

func try_and_loop():
	if current_enemy != null:
		print("loop assist")
		var rope_End = $Rope.get_point_interpolate(1)
		$Rope.gravity_direction = rope_End.direction_to(current_enemy.position)
	
func _on_hit() -> void:
	print("player hit")
	get_tree().paused = true
	hide()

func _on_near_enemy(enemy: Node2D) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property($Rope, "gravity", 10, 1.0).set_trans(Tween.TRANS_CIRC)
	print("loop assist physics")
	if current_enemy == null:
		current_enemy = enemy

func _on_leaving_enemy(enemy: Node2D) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	if enemy == current_enemy:
		$Rope.gravity_direction = Vector2.ZERO
		tween.tween_property($Rope, "gravity", 0, 0.5).set_trans(Tween.TRANS_CIRC)
		print("normal loop physics")
		current_enemy = null
func _on_loop_enemy(enemy: Node2D) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	print("kill enemy")
	tween.tween_property(enemy, "scale", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(enemy.queue_free)
