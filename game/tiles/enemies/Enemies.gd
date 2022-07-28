extends Spatial

var enemy = preload("res://game/tiles/enemies/Enemy.tscn")

func spawn(position):
	var n = randi() % 10
	for _i in range(n):
		instantiate_enemy(position)

func instantiate_enemy(position):
	var instance = enemy.instance()
	add_child(instance)
	instance.global_transform.origin = position + Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))