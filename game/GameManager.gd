extends Node

const fall_acceleration: float = 9.81

var score: int = 0
var speed: float = 20.0

var main: Node
var player: Node
var grounds: Node
var minions: Node

var debug_overlay: Node

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
