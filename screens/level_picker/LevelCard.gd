extends Button

signal level_card_pressed(level_path)

var level_path: String

func set_path(_level_path: String):
	level_path = _level_path
	text = level_path.split(".")[0]

func _on_LevelCard_pressed():
	emit_signal("level_card_pressed", level_path)
