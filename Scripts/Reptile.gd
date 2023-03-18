extends KinematicBody2D

onready var reptileAnimation = $AnimatedSprite
onready var arrow_item_position = $AnimatedSprite/ArrowHitPoint
#onready var player = get_node()
var max_hp = 40
var current_hp

var facing = Vector2()




func _ready():
	current_hp = max_hp
	


func _physics_process(delta):
	#facing = player.global_position()
	pass


func _process(delta):
	reptileAnimation_loop(delta)


func reptileAnimation_loop(delta):
	var anim_mode = "Idle"
	var animation
	var anim_direction = "2"
	#var direction = direction2str(facing)
	
	animation = anim_mode + "_" + anim_direction
	reptileAnimation.play(animation)


#func direction2str(direction):
#	var angle = direction.angle()
#	if angle < 0:
#		angle += 2 * PI
#	var a = round(angle / PI * 4)
#	return str(a)

func OnHit(damage, angle):
	current_hp -= damage
	var my_texture = load("res://Assets/Characters/First Hero/Attack Bow/Arrow.png")
	var sprite = Sprite.new()
	sprite.look_at(angle)
	sprite.set_offset(Vector2(-9,-2))
	sprite.set_texture(my_texture)
	arrow_item_position.add_child(sprite)
	
	if current_hp <= 0:
		current_hp = 0
		OnDeath()
	

func OnDeath():
	queue_free()
	print("Reptile is Dead")
