extends Control

onready var game: GameManager = get_node("/root/GameManager")

func _on_Play_pressed():
	game.change_scene(game.game_scene_path, "play_infinite")

func _on_Select_pressed():
	game.change_scene(game.level_picker_scene_path, "init")
