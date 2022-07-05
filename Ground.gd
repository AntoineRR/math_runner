extends StaticBody

signal ground_deleted

export var speed = 20

var size: int = 80

func _process(delta):
	translation.z += speed*delta

func _on_VisibilityNotifier_screen_exited():
	emit_signal("ground_deleted")
	queue_free()
