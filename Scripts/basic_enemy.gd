extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player:= get_node("../Player")
@onready var enemy_restrictor := get_node("../NavigationRegion2D/Enemy_restrictor")
@onready var navigation_region = get_node("../NavigationRegion2D")
@export var speed = 180

signal start_chasing_player

var is_alive = true
var chasing_player = false

var global_restrict_poly = []
var global_nav_poly = []

var wander_timer = 0.0
var wander_target = Vector2.ZERO
const WANDER_INTERVAL = 1.5
var animated_sprite

func _ready():
	# Restriction area
	var restrict_poly = enemy_restrictor.get_node("CollisionPolygon2D").polygon
	for point in restrict_poly:
		global_restrict_poly.append(enemy_restrictor.to_global(point))

	var map_rid = navigation_region.get_navigation_map()
	navigation_agent.set_navigation_map(map_rid)
	
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play()  # Plays the default animation
	animated_sprite.play("default")
func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	if chasing_player == false:
		var player_pos = player.global_position
		var closest_point = get_closest_point_on_restrict(position)
		navigation_agent.target_position = closest_point
		if global_position.distance_to(closest_point) < 10:
			velocity = Vector2.ZERO
		else:
			velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	else:
		navigation_agent.target_position = player.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	move_and_slide()
	look_at(player.global_position)
	rotation += deg_to_rad(90)
func get_closest_point_on_restrict(target_point: Vector2) -> Vector2:
	var closest = Vector2.INF
	var closest_dist = INF
	for i in global_restrict_poly.size():
		var a = global_restrict_poly[i]
		var b = global_restrict_poly[(i + 1) % global_restrict_poly.size()]
		var p = Geometry2D.get_closest_point_to_segment(target_point, a, b)
		var d = target_point.distance_to(p)
		if d < closest_dist:
			closest = p
			closest_dist = d
	return closest
func _on_start_chasing_player() -> void:
	chasing_player = true
	navigation_region = get_node("../ChaseNavigationRegion2D")
	var map_rid = navigation_region.get_navigation_map()
	navigation_agent.set_navigation_map(map_rid)
