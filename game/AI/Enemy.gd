extends KinematicBody

var attracted = true
var chasing = false
var speed = 10

var velocity = Vector3.ZERO

onready var game = get_node("/root/GameManager")

func _physics_process(_delta):
	velocity.y -= game.fall_acceleration
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if attracted and chasing:
		velocity = (game.player.global_transform.origin - global_transform.origin).normalized() * speed
	else:
		velocity = get_floor_velocity()

func _on_VisibilityNotifier_screen_exited():
	queue_free()

func _on_Area_body_entered(body):
	if body.get_collision_layer_bit(0):
		chasing = true

func _on_Area_body_exited(body):
	if body.get_collision_layer_bit(0):
		chasing = false

func _on_Hitbox_body_entered(body):
	if body.get_collision_layer_bit(0):
		game.player.take_damage(1)
		queue_free()
	elif body.get_collision_layer_bit(3):
		body.die()
		queue_free()
