extends Node

const fall_acceleration = 9.81

var score: int = 0
var speed: float = 20.0

var main
var player
var grounds
var minions

func register_main(_main):
	main = _main

func register_player(_player):
	player = _player

func register_grounds(_grounds):
	grounds = _grounds

func register_minions(_minions):
	minions = _minions

func adjust_minions():
	minions.adjust_minions(player.health)

func update_score(value):
	score = value
	main.get_node("Score/Label").text = str(score)
