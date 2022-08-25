class_name Tile

enum Type { EMPTY=0, ONE_EFFECT=1, TWO_EFFECTS=2, ENEMIES=3 }

var type: int
var metadata: Dictionary

func _init(_type: int, _metadata: Dictionary):
	type = _type
	metadata = _metadata

func save() -> Dictionary:
	var serialized_metadata = metadata.duplicate(true)
	if metadata.has("effects"):
		serialized_metadata["effects"] = []
		for effect in metadata["effects"]:
			serialized_metadata["effects"].append(effect.save())
	return {
		"type": type,
		"metadata": serialized_metadata
	}
