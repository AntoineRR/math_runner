extends RigidBody

signal minion_exited_screen

var player

func _process(_delta):
	var attraction = (player.translation - translation)
	add_force(attraction, Vector3.ZERO)

func init(_player):
	player = _player

func _on_VisibilityNotifier_screen_exited():
	emit_signal("minion_exited_screen", self)
