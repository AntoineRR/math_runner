extends KinematicBody

export var speed = 15
export var fall_acceleration = 10

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	velocity.x = direction.x * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
