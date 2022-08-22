class_name Level

# Tile types used by the level, useful for preloading the scenes
var tile_types: Array
# Tiles making the level, in order of appearance
var ordered_tiles: Array
# Scrolling speed
var speed: int

func _init(_tile_types: Array, _ordered_tiles: Array, _speed: int):
	tile_types = _tile_types
	ordered_tiles = _ordered_tiles
	speed = _speed
