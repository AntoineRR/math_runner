# Run the LevelGenerator.tscn scene to get a random level generated by this script!
tool
extends Spatial
class_name LevelGenerator

onready var game: GameManager = get_node("/root/GameManager")

# Choose to launch the level after generating it
export (bool) var play_level

# The length of the level (number of tiles)
export (int, 1, 100) var min_length
export (int, 1, 100) var max_length

# The tile types to use for the start
export (Array, Tile.Type) var start_tile_types

# The tile types to use for the rest of the level
export (Array, Tile.Type) var tile_types

# The difficulty of the level
export (int, 1, 10) var difficulty
const MAX_DIFFICULTY: int = 10

export (String, DIR, GLOBAL) var save_folder

var level: Level

func _ready():
	# Checks
	assert(max_length >= min_length)
	assert(len(start_tile_types) != 0 and len(tile_types) != 0)
	# Generate random level based on parameters
	level = generate_random_level()
	# Launch MainGame with this level
	if play_level:
		launch_game()

func launch_game():
	var main_game = load(game.game_scene_path).instance()
	get_tree().root.call_deferred("add_child", main_game)
	yield(get_tree(), "idle_frame") # Wait for end of call deferred
	main_game.play_level(level)

func get_speed() -> int:
	var min_speed := 20
	var speed = min_speed + difficulty * 2
	return speed

func generate_random_effect() -> Effect:
	var effect_type_picker := randf()
	var threshold = (MAX_DIFFICULTY - difficulty) / MAX_DIFFICULTY
	var effect_type
	var effect_value
	if effect_type_picker < threshold:
		effect_type = [Effect.Type.ADD, Effect.Type.MULTIPLY][randi() % 2]
		effect_value = randi() % (MAX_DIFFICULTY - difficulty + 1) + 1
	else:
		effect_type = [Effect.Type.SUBSTRACT, Effect.Type.DIVIDE][randi() % 2]
		effect_value = randi() % difficulty + 1
	return Effect.new(effect_type, effect_value)

func generate_random_metadata(type: int) -> Dictionary:
	if type == Tile.Type.ONE_EFFECT:
		return {
			"effects": [generate_random_effect()]
		}
	elif type == Tile.Type.TWO_EFFECTS:
		return {
			"effects": [generate_random_effect(), generate_random_effect()]
		}
	elif type == Tile.Type.ENEMIES:
		return {
			"n_enemies": [difficulty + randi() % 5]
		}
	else:
		return {}

func generate_random_tile(type: int, unique_types: Array) -> Tile:
	var tile = Tile.new(type, generate_random_metadata(type))
	if not tile.type in unique_types:
		unique_types.append(tile.type)
	return tile

func generate_random_level() -> Level:
	var length = min_length + randi() % (max_length - min_length)
	var tiles = []
	var unique_types = []
	# Speed
	var speed = get_speed()
	# First tile
	tiles.append(generate_random_tile(start_tile_types[randi() % len(start_tile_types)], unique_types))
	# Remaining tiles
	for _i in range(length - 1):
		tiles.append(generate_random_tile(tile_types[randi() % len(tile_types)], unique_types))
	return Level.new(unique_types, tiles, speed)


func _on_Save_pressed():
	var level_data = level.save()
	var level_file = File.new()
	var suffix = str(difficulty) + "_" + str(randi())
	var path = save_folder + "/" + suffix + ".json"
	print("Saving to " + path)
	level_file.open(path, File.WRITE)
	level_file.store_line(to_json(level_data))
	level_file.close()
	print("Level saved!")
