extends KinematicBody

export var speed: int = 15

onready var game: GameManager = get_node("/root/GameManager")

var health: int = 1
var velocity: Vector3 = Vector3.ZERO

func _ready():
	game.register_player(self)

func _physics_process(_delta: float):
	var direction = Vector3.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.z = Input.get_axis("ui_up", "ui_down")
	
	velocity = direction * speed
	velocity.y -= game.fall_acceleration
	velocity = move_and_slide(velocity)

func take_damage(amount: int):
	health = int(max(health - amount, 0))
	game.adjust_minions()
	game.update_score(health)
