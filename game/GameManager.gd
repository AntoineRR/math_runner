extends Node

const home_scene_path: String = "res://screens/home/Home.tscn"
const game_scene_path: String = "res://game/MainGame.tscn"

const fall_acceleration: float = 9.81

var loading_scene: Resource = load("res://screens/Loading.tscn")

var score: int = 0
var speed: float = 20.0

var main: Node
var player: Node
var grounds: Node
var minions: Node

var debug_overlay: Node

func _ready():
	randomize()

func register_main(_main: Node):
	main = _main

func register_player(_player: Node):
	player = _player

func register_grounds(_grounds: Node):
	grounds = _grounds

func register_minions(_minions: Node):
	minions = _minions

func register_debug_overlay(_debug_overlay: Node):
	debug_overlay = _debug_overlay

func adjust_minions():
	minions.adjust_minions(player.health)

func update_score(value: int):
	score = value
	main.get_node("Score/Label").text = str(score)

func reset():
	player.health = 1
	update_score(1)

func change_scene(new_scene_path: String, init_method = null):
	# Remove previous scene
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	root.call_deferred("remove_child", current_scene)
	current_scene.call_deferred("free")

	# Add loading screen
	var loading_screen = loading_scene.instance()
	root.add_child(loading_screen)

	# Add next scene
	var loader = ResourceLoader.load_interactive(new_scene_path)
	while true:
		var res = loader.poll()
		if res == OK:
			loading_screen.get_node("ProgressBar").value = (float(loader.get_stage()) / loader.get_stage_count()) * 100
		elif res == ERR_FILE_EOF:
			var next_scene = loader.get_resource().instance()
			root.call_deferred("remove_child", loading_screen)
			loading_screen.call_deferred("free")
			root.add_child(next_scene)
			if init_method != null and next_scene.has_method(init_method):
				next_scene.call(init_method)
			break
		yield(get_tree(), "idle_frame")

func load_level(path: String) -> Level:
	var level_file = File.new()
	if not level_file.file_exists(path):
		return null
	level_file.open(path, File.READ)
	var level_data = parse_json(level_file.get_line())
	level_file.close()
	
	var ordered_tiles = []
	for tile_data in level_data["ordered_tiles"]:
		var metadata = tile_data["metadata"].duplicate(true)
		if tile_data.has("effects"):
			metadata["effects"] = []
			for effect_data in tile_data["effects"]:
				var effect = Effect.new(effect_data["type"], effect_data["value"])
				metadata["effects"].append(effect)
		var tile = Tile.new(tile_data["type"], metadata)
		ordered_tiles.append(tile)
	var level = Level.new(level_data["tile_types"], ordered_tiles, level_data["speed"])
	return level
