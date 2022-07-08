extends GutTest

var effect_zone
var effect_type

func before_all():
	effect_zone = load('res://game/EffectZone.gd').new()
	effect_type = effect_zone.EffectType

func test_add():
	var effect = effect_zone.Effect.new(effect_type.ADD, 2)
	assert_eq(effect.apply(5), 7)

func test_substract():
	var effect = effect_zone.Effect.new(effect_type.SUBSTRACT, 2)
	assert_eq(effect.apply(5), 3)

func test_substract_below_zero():
	var effect = effect_zone.Effect.new(effect_type.SUBSTRACT, 7)
	assert_eq(effect.apply(5), 0)

func test_multiply():
	var effect = effect_zone.Effect.new(effect_type.MULTIPLY, 2)
	assert_eq(effect.apply(5), 10)

func test_divide():
	var effect = effect_zone.Effect.new(effect_type.DIVIDE, 2)
	assert_eq(effect.apply(5), 2)