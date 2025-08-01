extends Area2D

@export var speed: float = 200
@onready var player:= get_node("../Player")
var direction

func _ready():
	direction = Vector2.RIGHT.rotated(rotation)
	add_to_group("bullets")

func _physics_process(delta):
	position += direction * speed * delta
	#Vector2(cos(angle)* speed * delta,sin(angle)* speed * delta)
	
func _on_body_entered(body: Node2D) -> void:
	print("bullet hit")
	player.emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free() 
