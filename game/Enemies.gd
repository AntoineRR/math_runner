extends Spatial

var enemy: PackedScene = preload("res://game/AI/Enemy.tscn")

func spawn(spawnpoint: SpawnPoint):
	for _i in range(spawnpoint.n_enemies):
		instantiate_enemy(spawnpoint.global_transform.origin)

func instantiate_enemy(position: Vector3):
	var instance = enemy.instance()
	add_child(instance)
	instance.global_transform.origin = position + Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))
