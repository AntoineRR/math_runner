extends KinematicBody

signal ground_deleted
signal effect_zone_entered(health_diff)

export var size: int = 80
export var spawnpoints: Array

func _on_VisibilityNotifier_screen_exited():
	emit_signal("ground_deleted")
	queue_free()

func _on_effect_zone_entered(diff):
	emit_signal("effect_zone_entered", diff)

func _on_Deactivate_body_entered(body):
	body.attracted = false
