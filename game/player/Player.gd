extends KinematicBody

export var speed = 15

onready var game = get_node("/root/GameManager")

var health: int = 1
var velocity = Vector3.ZERO

func _ready():
	game.register_player(self)

func _physics_process(_delta):
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
	velocity.y -= game.fall_acceleration
	velocity = move_and_slide(velocity)

func take_damage(amount: int):
	health = int(max(health - amount, 0))
	game.adjust_minions()
	game.update_score(health)
