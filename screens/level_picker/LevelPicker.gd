extends Control

var level_card: PackedScene = preload("res://screens/level_picker/LevelCard.tscn")

onready var game: GameManager = get_node("/root/GameManager")

func init():
	populate_grid()

func list_files_in_directory(path) -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(path + "/" + file)

	dir.list_dir_end()

	return files

func populate_grid():
	var levels = list_files_in_directory(game.levels_path)
	for level in levels:
		var instance = level_card.instance()
		instance.set_path(level)
		instance.connect("level_card_pressed", self, "_on_level_card_pressed")
		$ScrollContainer/GridContainer.call_deferred("add_child", instance)

func _on_level_card_pressed(level_path):
	var level = game.load_level(level_path)
	game.change_scene(game.game_scene_path, "play_level", level)
