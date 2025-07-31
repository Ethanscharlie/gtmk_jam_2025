extends Area2D

@export var speed: float = 200
@onready var player:= get_node("../Player")

func _physics_process(delta):
	position += transform.x * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	print("bullet hit")
	player.emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free() 
