extends Spatial

signal effect_activated(health_diff)
signal spawn_enemies(position)

onready var game = get_node("/root/GameManager")

export var n_preloaded_tiles: int = 4

var default_tile = preload("res://game/tiles/Ground.tscn")
var tiles = [
	preload("res://game/tiles/GroundWithEffectZones.tscn"),
	preload("res://game/tiles/GroundWithEnemies.tscn"),
]
var loaded_tiles: Array = []

func _ready():
	game.register_grounds(self)

func _physics_process(delta):
	for elt in loaded_tiles:
		if elt.is_inside_tree():
			elt.global_transform.origin.z += game.speed*delta

func init():
	instanciate_tile(default_tile)
	for _i in range(n_preloaded_tiles - 1):
		instanciate_tile()

func instanciate_tile(tile = null):
	if tile == null:
		# Choose a random tile and instance it
		tile = tiles[randi() % len(tiles)]
	var instance = tile.instance()
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

func _on_effect_zone_entered(diff):
	emit_signal("effect_activated", diff)
