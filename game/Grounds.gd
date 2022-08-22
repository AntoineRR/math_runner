extends Spatial

signal effect_activated(health_diff)
signal spawn_enemies(spawnpoint)

onready var game: GameManager = get_node("/root/GameManager")

export var n_instanced_tiles: int = 4

var tiles_map: Dictionary = {
	Tile.Type.EMPTY: "res://game/tiles/Ground.tscn",
	Tile.Type.ONE_EFFECT: "res://game/tiles/GroundWithOneEffectZone.tscn",
	Tile.Type.TWO_EFFECTS: "res://game/tiles/GroundWithTwoEffectZones.tscn",
	Tile.Type.ENEMIES: "res://game/tiles/GroundWithEnemies.tscn",
}
var loaded_tiles: Dictionary = {}
var instanced_tiles: Array = []

var level: Level
var tile_index: int

func _ready():
	game.register_grounds(self)

func _physics_process(delta: float):
	for elt in instanced_tiles:
		if elt != null and weakref(elt).get_ref() != null and elt.is_inside_tree():
			elt.global_transform.origin.z += game.speed * delta

func init():
	for tile in tiles_map:
		loaded_tiles[tile] = load(tiles_map[tile])
	for _i in range(n_instanced_tiles - 1):
		instanciate_tile()

func play_level(_level: Level):
	level = _level
	# load scenes
	for tile_type in level.tile_types:
		loaded_tiles[tile_type] = load(tiles_map[tile_type])
	# Instanciate at most n_instanced_tiles at the same time
	tile_index = 0
	while len(instanced_tiles) < n_instanced_tiles and tile_index < len(level.ordered_tiles):
		var tile = level.ordered_tiles[tile_index]
		instanciate_tile(tile)
		tile_index += 1

func instanciate_tile(tile = null):
	if tile == null:
		# Choose a random tile and instance it
		var type = tiles_map.keys()[randi() % len(tiles_map.keys())]
		tile = LevelGenerator.new().generate_random_tile(type, [])
	var instance = loaded_tiles[tile.type].instance()
	instance.init(tile.metadata)
	# Move it to the right position
	if len(instanced_tiles) != 0:
		var last = instanced_tiles[len(instanced_tiles) - 1]
		instance.translation.z = last.translation.z - last.size / 2 - instance.size / 2
	# Connect signals
	instance.connect("ground_deleted", self, "_on_ground_deleted")
	instance.connect("effect_zone_entered", self, "_on_effect_zone_entered")
	# Add tile to the current tiles
	instanced_tiles.append(instance)
	call_deferred("add_child", instance)
	yield(get_tree(), "idle_frame") # Wait for end of call deferred
	# Summon enemies
	for spawnpoint in instance.spawnpoints:
		emit_signal("spawn_enemies", instance.get_node(spawnpoint))

func _on_ground_deleted():
	instanced_tiles.pop_front()
	if level != null:
		if tile_index < len(level.ordered_tiles):
			var tile = level.ordered_tiles[tile_index]
			instanciate_tile(tile)
			tile_index += 1
	else:
		instanciate_tile()

func _on_effect_zone_entered(diff: int):
	emit_signal("effect_activated", diff)
