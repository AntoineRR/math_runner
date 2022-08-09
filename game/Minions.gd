extends Spatial

signal minion_destroyed

export var chunk: int = 10

onready var game: GameManager = get_node("/root/GameManager")
var minion: PackedScene = preload("res://game/AI/Minion.tscn")
var loaded_minions: Array = []
var to_instantiate: int = 0
var to_delete: int = 0

func _ready():
	game.register_minions(self)

# We only treat at most a chunk of minion each frame
# This avoids frame drops when instantiating a lot of minions
func _process(_delta: float):
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

func adjust_minions(new_health: int):
	if new_health - 1 > len(loaded_minions):
		to_instantiate = new_health - 1 - len(loaded_minions)
	elif new_health - 1 < len(loaded_minions):
		to_delete = len(loaded_minions) - int(max(new_health - 1, 0))

func instantiate_minion():
	var instance = minion.instance()
	instance.translation = game.player.translation + Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))
	instance.connect("minion_killed", self, "_on_minion_die")
	instance.connect("minion_exited_screen", self, "_on_minion_die")
	loaded_minions.append(instance)
	add_child(instance)

func destroy_minion(instance: Node):
	if instance == null:
		instance = loaded_minions[randi() % len(loaded_minions)]
	# Need to disconnect signal because it is sent when destroying the object
	instance.disconnect("minion_killed", self, "_on_minion_die")
	instance.disconnect("minion_exited_screen", self, "_on_minion_die")
	instance.queue_free()
	loaded_minions.erase(instance)

func _on_minion_die(instance: Node):
	destroy_minion(instance)
	emit_signal("minion_destroyed")
