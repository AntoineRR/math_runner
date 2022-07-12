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
	
	func get_display() -> String:
		var result = ""
		match self.effect_type:
			EffectType.ADD:
				result += "+"
			EffectType.SUBSTRACT:
				result += "-"
			EffectType.MULTIPLY:
				result += "x"
			EffectType.DIVIDE:
				result += "/"
		result += str(self.value)
		return result

var effect: Effect
onready var player_vars = get_node("/root/PlayerVariables")
onready var label = get_node("3DText/Viewport/Label")

func _ready():
	effect = Effect.new()
	label.text = effect.get_display()

func _on_EffectZone_body_entered(body):
	if body.get_collision_layer_bit(0):
		player_vars.health = effect.apply(player_vars.health)
		print(player_vars.health)
