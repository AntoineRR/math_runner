extends Area

enum EffectType {ADD, SUBSTRACT, MULTIPLY, DIVIDE}

class Effect:
	var MAX_VALUE: int = 10
	
	var effect_type
	var value: int
	
	func _init(_effect_type = null, _value = null):
		if _effect_type == null:
			_effect_type = EffectType.values()[randi() % EffectType.size()]
		if _value == null:
			_value = randi() % MAX_VALUE + 1
		self.effect_type = _effect_type
		self.value = _value
	
	func apply(n: int) -> int:
		match self.effect_type:
			EffectType.ADD:
				return n + self.value
			EffectType.SUBSTRACT:
				return int(max(n - self.value, 0))
			EffectType.MULTIPLY:
				return n * self.value
			EffectType.DIVIDE:
				return int(n / self.value)
		return n

var effect: Effect

func _ready():
	effect = Effect.new()

func _on_EffectZone_body_entered(body):
	if body.get_collision_layer_bit(0):
		get_node("/root/PlayerVariables").health = effect.apply(get_node("/root/PlayerVariables").health)
		print(get_node("/root/PlayerVariables").health)
