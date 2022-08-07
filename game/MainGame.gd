extends Spatial

onready var game = get_node("/root/GameManager")
onready var ground_container = $Grounds
onready var minion_container = $Minions
onready var enemies_container = $Enemies
onready var score_label = $Score/Label

func _ready():
	game.register_main(self)
	randomize()
	game.player.health = 1
	game.update_score(1)
	ground_container.init()

func _on_Minions_minion_destroyed():
	game.player.take_damage(1)

func _on_Grounds_effect_activated(diff: int):
	game.player.take_damage(diff)

func _on_Grounds_spawn_enemies(position):
	enemies_container.spawn(position)

func _on_Bottom_body_entered(body):
	if body.get_collision_layer_bit(3):
		body.die()
	else:
		body.queue_free()
