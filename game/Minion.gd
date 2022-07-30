extends RigidBody

signal minion_exited_screen

var attracted = true
onready var game = get_node("/root/GameManager")

func _process(_delta):
	if attracted:
		var attraction = game.player.global_transform.origin - global_transform.origin
		add_force(attraction, Vector3.ZERO)

func _on_VisibilityNotifier_screen_exited():
	emit_signal("minion_exited_screen", self)
