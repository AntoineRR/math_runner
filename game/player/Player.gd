extends KinematicBody

export var speed = 15
export var fall_acceleration = 10

onready var grounds = get_node("/root/GameManager").grounds

var velocity = Vector3.ZERO

func _ready():
	get_node("/root/PlayerVariables").register_player(self)

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	
	velocity = direction * speed
	velocity.y -= fall_acceleration
	velocity = move_and_slide(velocity)
