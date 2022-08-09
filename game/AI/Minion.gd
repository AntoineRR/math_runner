extends RigidBody

signal minion_exited_screen(minion)
signal minion_killed(minion)

var attracted: bool = true
var attraction_strength: int = 5
onready var game: GameManager = get_node("/root/GameManager")

func _physics_process(_delta: float):
	if attracted:
		var attraction = (game.player.global_transform.origin - global_transform.origin) * attraction_strength
		add_force(attraction, Vector3.ZERO)

func die():
	emit_signal("minion_killed", self)

func _on_VisibilityNotifier_screen_exited():
	emit_signal("minion_exited_screen", self)
