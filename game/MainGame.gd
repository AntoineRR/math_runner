extends Spatial

onready var player_vars = get_node("/root/PlayerVariables")
onready var ground_container = $Grounds
onready var minion_container = $Minions
onready var enemies_container = $Enemies
onready var score_label = $Score/Label

func _ready():
	randomize()
	player_vars.health = 1
	ground_container.init()
	update_score()

func update_score():
	score_label.text = str(player_vars.health)

func _on_Minions_minion_destroyed():
	player_vars.health = max(player_vars.health - 1, 0)
	update_score()

func _on_Grounds_effect_activated():
	minion_container.adjust_minions(player_vars.health)
	update_score()

func _on_Grounds_spawn_enemies(position):
	enemies_container.spawn(position)
