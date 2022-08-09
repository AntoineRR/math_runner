extends Spatial

var enemy: PackedScene = preload("res://game/AI/Enemy.tscn")

func spawn(position: Vector3):
	var n = randi() % 10
	for _i in range(n):
		instantiate_enemy(position)

func instantiate_enemy(position: Vector3):
	var instance = enemy.instance()
	add_child(instance)
	instance.global_transform.origin = position + Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))
