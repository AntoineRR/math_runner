extends GutTest

var sender = InputSender.new(Input)

func after_each():
	sender.release_all()
	sender.clear()

func test_move_left():
	var player = add_child_autofree(load("res://game/Player.gd").new())

	sender.action_down("move_left").hold_for(.2).wait(.3)
	yield(sender, 'idle')

	assert_between(player.translation.x, -5.0, -1.0)

func test_move_right():
	var player = add_child_autofree(load("res://game/Player.gd").new())

	sender.action_down("move_right").hold_for(.2).wait(.3)
	yield(sender, 'idle')

	assert_between(player.translation.x, 1.0, 5.0)
