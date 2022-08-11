class_name Effect

enum Type {ADD, SUBSTRACT, MULTIPLY, DIVIDE}

var type: int
var value: int

func _init(_type: int, _value: int):
	type = _type
	value = _value
