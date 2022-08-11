class_name Level

# Tile types used by the level, useful for preloading the scenes
var used_tiles: Array
# Tiles making the level, in order of appearance
var ordered_tiles: Array
# Scrolling speed
var speed: int

func _init(_used_tiles: Array, _ordered_tiles: Array, _speed: int):
	used_tiles = _used_tiles
	ordered_tiles = _ordered_tiles
	speed = _speed
