extends Control

onready var game: GameManager = get_node("/root/GameManager")
onready var label: Node = $Label

var stats: Array = []

class Stat:
	var display_name: String
	var object: Object
	var stat: String
	var is_method: bool
	
	func _init(_display_name: String, _object: Object, _stat: String, _is_method: bool):
		display_name = _display_name
		object = _object
		stat = _stat
		is_method = _is_method

func _ready():
	game.register_debug_overlay(self)
	add_stat("FPS", Engine, "get_frames_per_second", true)

func _process(_delta: float):
	var to_display = ""
	var new_stats = []
	for stat in stats:
		if stat.object != null and weakref(stat.object).get_ref() != null:
			to_display += format_stat(stat) + "\n"
			new_stats.append(stat)
	label.text = to_display
	stats = new_stats

func add_stat(display_name: String, object: Object, stat: String, is_method: bool):
	stats.append(Stat.new(display_name, object, stat, is_method))

func format_stat(stat: Stat):
	var value
	if stat.is_method:
		value = stat.object.call(stat.stat)
	else:
		value = stat.object.get(stat.stat)
	return stat.display_name + ": " + str(value)
