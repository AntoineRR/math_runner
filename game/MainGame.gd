extends Spatial

var ground = preload("res://game/Ground.tscn")
var minion = preload("res://game/Minion.tscn")
onready var player_vars = get_node("/root/PlayerVariables")

export var n_preloaded_grounds: int = 2

var loaded_grounds: Array = []
var loaded_minions: Array = []

func _ready():
	randomize()
	player_vars.health = 1
	for _i in range(n_preloaded_grounds):
		instanciate_ground()

func instanciate_ground():
	var instance = ground.instance()
	var n = len(loaded_grounds)
	if n != 0:
		instance.translation.z -= n * instance.size - loaded_grounds[0].translation.z
	instance.connect("ground_deleted", self, "_on_ground_deleted")
	instance.connect("effect_zone_entered", self, "_on_effect_zone_entered")
	loaded_grounds.append(instance)
	$Grounds.call_deferred("add_child", instance)

func _on_ground_deleted():
	loaded_grounds.pop_front()
	instanciate_ground()

func _on_effect_zone_entered():
	while len(loaded_minions) < player_vars.health - 1:
		instanciate_minion()
	while len(loaded_minions) > max(player_vars.health - 1, 0):
		destroy_minion(null)
	print(player_vars.health)

func instanciate_minion():
	var instance = minion.instance()
	instance.init($Player)
	instance.translation = $Player.translation
	instance.connect("minion_exited_screen", self, "_on_minion_exited_screen")
	loaded_minions.append(instance)
	$Minions.call_deferred("add_child", instance)

func destroy_minion(instance):
	if instance == null:
		instance = loaded_minions[randi() % len(loaded_minions)]
	# Need to disconnect signal because it is sent when destroying the object
	instance.disconnect("minion_exited_screen", self, "_on_minion_exited_screen")
	instance.queue_free()
	loaded_minions.erase(instance)

func _on_minion_exited_screen(instance):
	destroy_minion(instance)
	player_vars.health = max(player_vars.health - 1, 0)
	print(player_vars.health)
