extends RigidBody2D


var projectile_speed = Vector2(1200,0)
var angle = null
export var life_time = 10
export var arrow_damage = 10

func _ready():
	set_as_toplevel(true)
	apply_impulse(Vector2(), Vector2(projectile_speed).rotated(rotation))
	angle = Vector2(projectile_speed).rotated(rotation)

func SelfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_Arrow_body_entered(body):
	if body.is_in_group("Enemies"):
		get_parent().queue_free()
		body.OnHit(arrow_damage, angle)
