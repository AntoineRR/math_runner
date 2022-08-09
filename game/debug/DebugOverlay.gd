extends Control

onready var game = get_node("/root/GameManager")
onready var label = $Label

var stats: Array = []

class Stat:
	var name
	var object
	var stat
	var is_method
	
	func _init(_name, _object, _stat, _is_method):
		name = _name
		object = _object
		stat = _stat
		is_method = _is_method

func _ready():
	game.register_debug_overlay(self)
	add_stat("FPS", Engine, "get_frames_per_second", true)

func _process(_delta):
	var to_display = ""
	var new_stats = []
	for stat in stats:
		if stat.object != null and weakref(stat.object).get_ref() != null:
			to_display += format_stat(stat) + "\n"
			new_stats.append(stat)
	label.text = to_display
	stats = new_stats

func add_stat(name, object, stat, is_method):
	stats.append(Stat.new(name, object, stat, is_method))

func format_stat(stat):
	var value
	if stat.is_method:
		value = stat.object.call(stat.stat)
	else:
		value = stat.object.get(stat.stat)
	return stat.name + ": " + str(value)
