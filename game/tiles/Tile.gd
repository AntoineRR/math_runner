class_name Tile

enum Type { EMPTY=0, ONE_EFFECT=1, TWO_EFFECTS=2, ENEMIES=3 }

var type: int
var metadata: Dictionary

func _init(_type: int, _metadata: Dictionary):
	type = _type
	metadata = _metadata
