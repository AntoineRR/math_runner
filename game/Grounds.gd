extends Spatial

signal effect_activated
signal spawn_enemies(position)

onready var game = get_node("/root/GameManager")

export var n_preloaded_tiles: int = 4

var tiles = [preload("res://game/tiles/Ground.tscn"), preload("res://game/tiles/enemies/Enemies.tscn")]
var loaded_tiles: Array = []

func _process(delta):
	for elt in loaded_tiles:
		elt.global_transform.origin.z += game.speed*delta

func init():
	for _i in range(n_preloaded_tiles):
		instanciate_tile()

func instanciate_tile():
	# Choose a random tile and instance it
	var instance = tiles[randi() % len(tiles)].instance()
	# Move it to the right position
	if len(loaded_tiles) != 0:
		var last = loaded_tiles[len(loaded_tiles) - 1]
		instance.translation.z = last.translation.z - last.size / 2 - instance.size / 2
	# Connect signals
	instance.connect("ground_deleted", self, "_on_ground_deleted")
	instance.connect("effect_zone_entered", self, "_on_effect_zone_entered")
	# Add tile to the current tiles
	loaded_tiles.append(instance)
	call_deferred("add_child", instance)
	yield(get_tree(), "idle_frame") # Wait for end of call deferred
	# Summon enemies
	for spawnpoint in instance.spawnpoints:
		emit_signal("spawn_enemies", instance.get_node(spawnpoint).global_transform.origin)

func _on_ground_deleted():
	loaded_tiles.pop_front()
	instanciate_tile()

func _on_effect_zone_entered():
	emit_signal("effect_activated")