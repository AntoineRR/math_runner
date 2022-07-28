extends RigidBody

signal minion_exited_screen

var attracted = true
onready var player = get_node("/root/PlayerVariables").player

func _process(_delta):
	if attracted:
		var attraction = player.global_transform.origin - global_transform.origin
		add_force(attraction, Vector3.ZERO)

func _on_VisibilityNotifier_screen_exited():
	emit_signal("minion_exited_screen", self)
