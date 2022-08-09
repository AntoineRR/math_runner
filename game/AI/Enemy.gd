extends KinematicBody

var attracted: bool = true
var chasing: bool = false
var deadly: bool = true
var speed: int = 10

var velocity: Vector3 = Vector3.ZERO

onready var game: GameManager = get_node("/root/GameManager")

func _physics_process(_delta: float):
	velocity.y -= game.fall_acceleration
	velocity = move_and_slide(velocity, Vector3.UP)
	if attracted and chasing:
		velocity = (game.player.global_transform.origin - global_transform.origin).normalized() * speed

func _on_VisibilityNotifier_screen_exited():
	queue_free()

func _on_Area_body_entered(body: PhysicsBody):
	if body.get_collision_layer_bit(0):
		chasing = true

func _on_Area_body_exited(body: PhysicsBody):
	if body.get_collision_layer_bit(0):
		chasing = false

func _on_Hitbox_body_entered(body: PhysicsBody):
	if deadly:
		if body.get_collision_layer_bit(0):
			deadly = false
			game.player.take_damage(1)
			queue_free()
		elif body.get_collision_layer_bit(3):
			deadly = false
			body.die()
			queue_free()
