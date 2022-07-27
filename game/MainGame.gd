extends Spatial

var ground = preload("res://game/Ground.tscn")
onready var player_vars = get_node("/root/PlayerVariables")
onready var ground_container = $Grounds
onready var minion_container = $Minions
onready var score_label = $Score/Label

export var n_preloaded_grounds: int = 4

var loaded_grounds: Array = []

func _ready():
	randomize()
	player_vars.health = 1
	for _i in range(n_preloaded_grounds):
		instanciate_ground()
	update_score()

func instanciate_ground():
	var instance = ground.instance()
	var n = len(loaded_grounds)
	if n != 0:
		instance.translation.z -= n * instance.size - loaded_grounds[0].translation.z
	instance.connect("ground_deleted", self, "_on_ground_deleted")
	instance.connect("effect_zone_entered", self, "_on_effect_zone_entered")
	loaded_grounds.append(instance)
	ground_container.call_deferred("add_child", instance)

func update_score():
	score_label.text = str(player_vars.health)

func _on_ground_deleted():
	loaded_grounds.pop_front()
	instanciate_ground()

func _on_effect_zone_entered():
	minion_container.adjust_minions(player_vars.health)
	update_score()

func _on_Minions_minion_destroyed():
	player_vars.health = max(player_vars.health - 1, 0)
	update_score()
