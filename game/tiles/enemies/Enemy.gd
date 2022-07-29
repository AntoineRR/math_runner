extends RigidBody

var attracted = true
onready var game = get_node("/root/GameManager")
onready var player = get_node("/root/PlayerVariables").player

func _process(_delta):
	if attracted:
		var attraction = player.global_transform.origin - global_transform.origin
		if attraction.length() < 20:
			add_force(attraction, Vector3.ZERO)

func _on_VisibilityNotifier_screen_exited():
	queue_free()
