extends KinematicBody

signal ground_deleted
signal effect_zone_entered(health_diff)

export var size: int = 80
export (Array, NodePath) var spawnpoints
export (Array, NodePath) var effect_zones

func init(metadata: Dictionary):
	if metadata.has("effects"):
		assert(len(metadata["effects"]) == len(effect_zones))
		var index = 0
		while index < len(effect_zones):
			get_node(effect_zones[index]).init(metadata["effects"][index])
			index += 1
	if metadata.has("n_enemies"):
		assert(len(metadata["n_enemies"]) == len(spawnpoints))
		var index = 0
		while index < len(spawnpoints):
			get_node(spawnpoints[index]).init(metadata["n_enemies"][index])
			index += 1
		

func _on_VisibilityNotifier_screen_exited():
	emit_signal("ground_deleted")
	queue_free()

func _on_effect_zone_entered(diff: int):
	emit_signal("effect_zone_entered", diff)

func _on_Deactivate_body_entered(body: PhysicsBody):
	body.attracted = false
