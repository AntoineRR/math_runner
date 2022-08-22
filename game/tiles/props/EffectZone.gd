extends Area

signal effect_zone_entered(health_diff)

onready var game: GameManager = get_node("/root/GameManager")
onready var label: Node = get_node("3DText/Viewport/Label")

var effect: Effect

func init(_effect = null):
	if _effect == null:
		var type = Effect.Type.values()[randi() % Effect.Type.size()]
		var value = randi() % 9 + 1
		_effect = Effect.new(type, value)
	effect = _effect
	get_node("3DText/Viewport/Label").text = get_display()

func apply(n: int) -> int:
	match effect.type:
		Effect.Type.ADD:
			return n + effect.value
		Effect.Type.SUBSTRACT:
			return int(max(n - effect.value, 0))
		Effect.Type.MULTIPLY:
			return n * effect.value
		Effect.Type.DIVIDE:
			return int(n / effect.value)
	return n

func get_display() -> String:
	var result = ""
	match effect.type:
		Effect.Type.ADD:
			result += "+"
		Effect.Type.SUBSTRACT:
			result += "-"
		Effect.Type.MULTIPLY:
			result += "x"
		Effect.Type.DIVIDE:
			result += "/"
	result += str(effect.value)
	return result

func _on_EffectZone_body_entered(body: PhysicsBody):
	if body.get_collision_layer_bit(0):
		var diff: int = int(game.player.health - apply(game.player.health))
		emit_signal("effect_zone_entered", diff)
