extends GutTest

var effect_zone

func before_all():
	effect_zone = load("res://game/tiles/props/EffectZone.tscn").instance()

func test_add():
	effect_zone.effect = Effect.new(Effect.Type.ADD, 2)
	assert_eq(effect_zone.apply(5), 7)
	assert_eq(effect_zone.get_display(), "+2")

func test_substract():
	effect_zone.effect = Effect.new(Effect.Type.SUBSTRACT, 2)
	assert_eq(effect_zone.apply(5), 3)
	assert_eq(effect_zone.get_display(), "-2")

func test_substract_below_zero():
	effect_zone.effect = Effect.new(Effect.Type.SUBSTRACT, 7)
	assert_eq(effect_zone.apply(5), 0)
	assert_eq(effect_zone.get_display(), "-7")

func test_multiply():
	effect_zone.effect = Effect.new(Effect.Type.MULTIPLY, 2)
	assert_eq(effect_zone.apply(5), 10)
	assert_eq(effect_zone.get_display(), "x2")

func test_divide():
	effect_zone.effect = Effect.new(Effect.Type.DIVIDE, 2)
	assert_eq(effect_zone.apply(5), 2)
	assert_eq(effect_zone.get_display(), "/2")
