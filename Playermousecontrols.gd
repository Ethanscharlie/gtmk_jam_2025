extends CharacterBody2D

@export var normal_speed = 200.0
@export var boost_speed = 400.0
@export var follow_distance = 10.0
@export var position_threshold = 5.0
@export var stuck_limit = 5

var current_speed: float
var last_positions: Array[Vector2] = []
var stuck_counter = 0
var is_stuck = false
var last_mouse_position: Vector2
var position_check_timer = 0.0
var check_interval = 0.1 # Check every 0.1 seconds

func _ready():
	current_speed = normal_speed
	last_mouse_position = get_global_mouse_position()

func _process(delta):
	# Check if mouse moved
	var current_mouse_pos = get_global_mouse_position()
	if current_mouse_pos.distance_to(last_mouse_position) > 10.0:
		if is_stuck:
			is_stuck = false
			stuck_counter = 0
			last_positions.clear()
			print("Mouse moved! Player can move again.")
		last_mouse_position = current_mouse_pos

func _physics_process(delta):
	# Update speed based on input (Hold key for speed boost)
	if Input.is_action_pressed("ui_accept"): # Change this to "speed_boost" for custom action
		current_speed = boost_speed
	else:
		current_speed = normal_speed
	
	if is_stuck:
		velocity = Vector2.ZERO
		return
	
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	
	if direction.length() > follow_distance:
		# Update position tracking
		position_check_timer += delta
		if position_check_timer >= check_interval:
			position_check_timer = 0.0
			check_for_stuck()
		
		velocity = direction.normalized() * current_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func check_for_stuck():
	last_positions.append(global_position)
	
	if last_positions.size() > stuck_limit:
		last_positions.pop_front()
	
	if last_positions.size() >= stuck_limit:
		var stuck_in_area = true
		for pos in last_positions:
			if pos.distance_to(global_position) > position_threshold:
				stuck_in_area = false
				break
		
		if stuck_in_area:
			is_stuck = true
			velocity = Vector2.ZERO
			print("Player stuck! Move mouse to continue.")
