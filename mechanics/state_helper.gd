extends Node
class_name StateHelper

static var player: PlayerBase

static func reset_states() -> void:
	states = start_states.duplicate()

static func gets(key: String) -> Variant:
	return states[key] if key in states else null

static func sets(key: String, value: Variant) -> void:
	states[key] = value

static var states = {
	# Used for debugging
	"demo_1": 0,
	"demo_2": 0,
	"demo_3": 0,
	
	# 0 - not interacted, 1 - interacted, 2 - ate an apple, 3 - refused to eat
	"evil_snake": 0,
	
	# 0 - didn't see, 1 - made it to the entrance, 2 - solved the puzzle
	"lucas_temple": 0,
}

static var start_states = states.duplicate()
