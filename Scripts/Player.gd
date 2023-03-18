extends KinematicBody2D

onready var playerAnimation = $AnimatedSprite

var max_speed = 500
var speed = 0
var acceleration = 1000
var move_direction = Vector2(0,0)
var anim_mode
var moving = false

var facing = Vector2()

var attacking = false
var attack_direction 

# Dashing Stats
export var dash_speed = 1000
export var dash_duration = 0.2
export var dash_cooldown = 1.0

var dash_timer = 0
var can_dash = true
var dash_direction = Vector2.ZERO

# Bow Shooting Stats
export var projectile_lifetime = 2.0
export var projectile_cooldown = 0.7

var projectile = preload("res://Scn/Arrow.tscn")
var can_shoot = true
var trying_to_shoot = false

var shooting = false
var aim_direction
var shoot_direction

var shooting_anim = null
var is_aiming = false
#var aiming_frame = 11


func _ready():
	anim_mode = "Idle"


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("Dash"):
			dash(move_direction)
	
	



func _unhandled_input(event):
	if event.is_action_pressed("LeftClick"):
		moving = false
		attacking = true
		attack_direction = rad2deg(get_angle_to(get_global_mouse_position()))
		Attack()
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			is_aiming = true
			shooting = false
			#trying_to_shoot = true
			aim_direction = rad2deg(get_angle_to(get_global_mouse_position()))
		
		
		elif event.button_index == BUTTON_RIGHT and event.is_action_released("RightClick"):
			if can_shoot:
				is_aiming = false
				shooting = true
				shoot_direction = rad2deg(get_angle_to(get_global_mouse_position()))
				shoot_Bow()
				can_shoot = false
				set_process_input(false)
				# Start a timer to reset the shooting cooldown
				yield(get_tree().create_timer(projectile_cooldown), "timeout")
				can_shoot = true
				set_process_input(true)
				#is_aiming = false
				# Calculate the direction from the player to the mouse position
				#var direction = get_global_mouse_position() 
			
		elif event.button_index == BUTTON_RIGHT:
			is_aiming = true
			shooting = false
			yield(get_tree().create_timer(0.67), "timeout")
			if can_shoot:
				is_aiming = false
				shooting = true
				shoot_direction = rad2deg(get_angle_to(get_global_mouse_position()))
				shoot_Bow()
				can_shoot = false
				set_process_input(false)
				# Start a timer to reset the shooting cooldown
				yield(get_tree().create_timer(projectile_cooldown), "timeout")
				can_shoot = true
				set_process_input(true)
		else:
			is_aiming = false
			shooting = false



func _physics_process(delta):
	MovementLoop(delta)
	dashingAbility(delta)
	

func _process(delta):
	AnimationLoop(delta)

func MovementLoop(delta):
	var Right = Input.is_action_pressed("Right")
	var Left = Input.is_action_pressed("Left")
	var Up = Input.is_action_pressed("Up")
	var Down = Input.is_action_pressed("Down")
	move_direction.x = int(Right) - int(Left)
	move_direction.y = (int(Down) - int(Up)) / float(2)
	if Left || Right || Up || Down:
		facing = move_direction
	
	
	if move_direction == Vector2(0,0) || Input.is_action_pressed("LeftClick") || attacking == true || is_aiming == true || shooting == true:
		moving = false
		speed = 0
	else:
		moving = true
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
		var motion = move_direction.normalized() * speed
		move_and_slide(motion)

# Sword Attack
func Attack():
	yield(get_tree().create_timer(1.2), "timeout")
	attacking = false
	#anim_mode = "Idle"

# Shoot Bow
func shoot_Bow():
	#if can_shoot:
	
	get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
	# Create a new Projectile instance and add it to the scene
	var proj = projectile.instance()
		
	proj.position = get_node("TurnAxis/CastPoint").get_global_position()
	proj.rotation = get_angle_to(get_global_mouse_position())
	#proj.velocity = direction.normalized() * projectile_speed
	get_parent().add_child(proj)
	# Start a timer to destroy the projectile after its lifetime expires
	#yield(get_tree().create_timer(projectile_lifetime), "timeout")
	#proj.queue_free()
	# Start a timer to reset the shooting cooldown
	#yield(get_tree().create_timer(projectile_cooldown), "timeout")
		
	#can_shoot = true
	#is_aiming = false
	yield(get_tree().create_timer(0.67), "timeout")
	shooting = false
	#trying_to_shoot = false
		



func AnimationLoop(delta):
	
	var animation
	anim_mode = "Idle"
	#var direction = direction2str(facing)
	var direction
	var attack_face_direction = Vector2()
	var aim_face_direction = Vector2()
	var shoot_face_direction = Vector2()
	# Direction Indicators
#	if a == 0:
#		anim_direction = "E"
#	elif a == 1:
#		anim_direction = "SE"
#	elif a == 2:
#		anim_direction = "S"
#	elif a == 3:
#		anim_direction = "SW"
#	elif a == 4:
#		anim_direction = "W"
#	elif a == 5:
#		anim_direction = "NW"
#	elif a == 6:
#		anim_direction = "N"
#	elif a == 7:
#		anim_direction = "NE"
	
	# Mouse Movements
#	var mouse = get_local_mouse_position()
#	a = stepify(mouse.angle(), PI/4) / (PI/4)
#	a = wrapi(int(a), 0, 8)
#
#	if moving == false:
#		speed = 0
#	if Input.is_action_pressed("Click") and mouse.length() > 10:
#		moving = true
#		anim_mode = "RunEmpty"
#		speed += acceleration * delta
#		if speed > max_speed:
#			speed = max_speed
#		move_and_slide(mouse.normalized() * speed)
	
	if moving == true:
		anim_mode = "RunEmpty"
	elif moving == false:
		anim_mode = "Idle"
	if attacking:
		if attack_direction <= 15 and attack_direction >= -15:
			#attack_face_direction = "0"
			attack_face_direction = Vector2(1,0)
		elif attack_direction <= 60 and attack_direction >= 15:
			#attack_face_direction = "1"
			attack_face_direction = Vector2(1,0.5)
		elif attack_direction <= 120 and attack_direction >= 60:
			#attack_face_direction = "2"
			attack_face_direction = Vector2(0,0.5)
		elif attack_direction <= 165 and attack_direction >= 120:
			#attack_face_direction = "3"
			attack_face_direction = Vector2(-1,0.5)
		elif attack_direction >= -60 and attack_direction <= -15:
			#attack_face_direction = "7"
			attack_face_direction = Vector2(1,-0.5)
		elif attack_direction >= -120 and attack_direction <= -60:
			#attack_face_direction = "6"
			attack_face_direction = Vector2(0,-0.5)
		elif attack_direction >= -165 and attack_direction <= -120:
			#attack_face_direction = "5"
			attack_face_direction = Vector2(-1,-0.5)
		elif attack_direction <= -165 or attack_direction >= 165:
			#attack_face_direction = "4"
			attack_face_direction = Vector2(-1,0)
		
		facing = attack_face_direction
		
		anim_mode = "AttackSword"
		
	if is_aiming:
		if aim_direction <= 15 and aim_direction >= -15:
			#attack_face_direction = "0"
			aim_face_direction = Vector2(1,0)
		elif aim_direction <= 60 and aim_direction >= 15:
			#attack_face_direction = "1"
			aim_face_direction = Vector2(1,0.5)
		elif aim_direction <= 120 and aim_direction >= 60:
			#attack_face_direction = "2"
			aim_face_direction = Vector2(0,0.5)
		elif aim_direction <= 165 and aim_direction >= 120:
			#attack_face_direction = "3"
			aim_face_direction = Vector2(-1,0.5)
		elif aim_direction >= -60 and aim_direction <= -15:
			#attack_face_direction = "7"
			aim_face_direction = Vector2(1,-0.5)
		elif aim_direction >= -120 and aim_direction <= -60:
			#attack_face_direction = "6"
			aim_face_direction = Vector2(0,-0.5)
		elif aim_direction >= -165 and aim_direction <= -120:
			#attack_face_direction = "5"
			aim_face_direction = Vector2(-1,-0.5)
		elif aim_direction <= -165 or aim_direction >= 165:
			#attack_face_direction = "4"
			aim_face_direction = Vector2(-1,0)
		
		facing = aim_face_direction
		
		anim_mode = "AimBow"
		
		
		
		
	if shooting:
		if shoot_direction <= 15 and shoot_direction >= -15:
			#attack_face_direction = "0"
			shoot_face_direction = Vector2(1,0)
		elif shoot_direction <= 60 and shoot_direction >= 15:
			#attack_face_direction = "1"
			shoot_face_direction = Vector2(1,0.5)
		elif shoot_direction <= 120 and shoot_direction >= 60:
			#attack_face_direction = "2"
			shoot_face_direction = Vector2(0,0.5)
		elif shoot_direction <= 165 and shoot_direction >= 120:
			#attack_face_direction = "3"
			shoot_face_direction = Vector2(-1,0.5)
		elif shoot_direction >= -60 and shoot_direction <= -15:
			#attack_face_direction = "7"
			shoot_face_direction = Vector2(1,-0.5)
		elif shoot_direction >= -120 and shoot_direction <= -60:
			#attack_face_direction = "6"
			shoot_face_direction = Vector2(0,-0.5)
		elif shoot_direction >= -165 and shoot_direction <= -120:
			#attack_face_direction = "5"
			shoot_face_direction = Vector2(-1,-0.5)
		elif shoot_direction <= -165 or shoot_direction >= 165:
			#attack_face_direction = "4"
			shoot_face_direction = Vector2(-1,0)
		
		facing = shoot_face_direction
		
		anim_mode = "ShootBow"
	
	direction = direction2str(facing)
			
	animation = anim_mode + "_" + direction
	playerAnimation.play(animation)
	
	
	
	
	
	
	
	

func direction2str(direction):
	var angle = direction.angle()
	if angle < 0:
		angle += 2 * PI
	var a = round(angle / PI * 4)
	return str(a)


# Dashing ability Function
func dashingAbility(delta):
	var velocity = Vector2.ZERO
	
	# Check if the player is dashing and update velocity accordingly
	if dash_timer > 0:
		velocity = dash_direction.normalized() * dash_speed
	
	# Move the player using the updated velocity
	move_and_slide(velocity)
	
	# Update the dash timer and check if it has expired
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0:
			dash_timer = 0
			can_dash = false
			set_process_input(false)
			yield(get_tree().create_timer(dash_cooldown), "timeout")
			can_dash = true
			set_process_input(true)
			

# Dash Direction
func dash(direction):
	if can_dash:
		dash_timer = dash_duration
		dash_direction = direction
		set_process_input(true)




