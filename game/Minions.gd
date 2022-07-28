extends Spatial

signal minion_destroyed

export var chunk = 10

onready var player = get_node("/root/PlayerVariables").player
var minion = preload("res://game/Minion.tscn")
var loaded_minions: Array = []
var to_instantiate = 0
var to_delete = 0

# We only treat at most a chunk of minion each frame
# This avoids frame drops when instantiating a lot of minions
func _process(_delta):
	if to_instantiate > 0:
		var to_do = chunk
		while to_do > 0 and to_instantiate > 0:
			instantiate_minion()
			to_instantiate -= 1
			to_do -= 1
	if to_delete > 0:
		while to_delete > 0:
			destroy_minion(null)
			to_delete -= 1

func adjust_minions(new_health):
	if new_health - 1 > len(loaded_minions):
		to_instantiate = new_health - 1 - len(loaded_minions)
	elif new_health - 1 < len(loaded_minions):
		to_delete = len(loaded_minions) - max(new_health - 1, 0)

func instantiate_minion():
	var instance = minion.instance()
	instance.translation = player.translation + Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))
	instance.connect("minion_exited_screen", self, "_on_minion_exited_screen")
	loaded_minions.append(instance)
	call_deferred("add_child", instance)

func destroy_minion(instance):
	if instance == null:
		instance = loaded_minions[randi() % len(loaded_minions)]
	# Need to disconnect signal because it is sent when destroying the object
	instance.disconnect("minion_exited_screen", self, "_on_minion_exited_screen")
	instance.queue_free()
	loaded_minions.erase(instance)

func _on_minion_exited_screen(instance):
	destroy_minion(instance)
	emit_signal("minion_destroyed")
