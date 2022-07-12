extends Spatial

var ground = preload("res://game/Ground.tscn")
onready var player_vars = get_node("/root/PlayerVariables")

export var n_preloaded_grounds: int = 2

var n_loaded_grounds: int = 0
var loaded_grounds: Array = []

func _ready():
	randomize()
	player_vars.health = 0
	for _i in range(n_preloaded_grounds):
		instanciate_ground()

func instanciate_ground():
	var instance = ground.instance()
	var n = len(loaded_grounds)
	if n != 0:
		instance.translation.z -= n * instance.size - loaded_grounds[0].translation.z
	instance.connect("ground_deleted", self, "_on_ground_deleted")
	loaded_grounds.append(instance)
	$Grounds.call_deferred("add_child", instance)
	n_loaded_grounds += 1

func _on_ground_deleted():
	n_loaded_grounds -= 1
	loaded_grounds.pop_front()
	instanciate_ground()
