extends Node
class_name StateHelper

static var player: PlayerBase

static func reset_states() -> void:
	states = start_states.duplicate()

static func gets(key: String) -> Variant:
	return states[key] if key in states else null

static func sets(key: String, value: Variant) -> void:
	states[key] = value
	QuestHelper.poll_quests()

static var states = {
	# Used for debugging
	"demo_1": 0,
	"demo_2": 0,
	"demo_3": 0,
	
	# 0 - not interacted, 1 - interacted, 2 - ate an apple, 3 - refused to eat
	"evil_snake": 0,
	
	# 0 - didn't see, 1 - made it to the entrance, 2 - solved the puzzle
	# 3 - talked with master, 4 - talked with big pig, 5 - told truth, 6 - told lies
	"lucas_temple": 0,
	
	# 0 - absent, 1 - in stock
	"red_key": 0,
	"green_key": 0,
	
	# The count of followers, 0 - not met anyone, 5 - met all of them
	"followers_acquainted": 0,
	# 0 - haven't talked, 1 - talked
	"asedine_talked": 0,
	"sticks_collected": 0,
	
	# 0 - placeholder, 1 - pineapple, -1 - pizza
	"pineapple_or_pizza": 0,
	
	# 0 - not met, 1 - met
	"ceo_met": 0,
	
	# 0 - game not finished, 1 - game finished
	"finished": 1,
}

static var start_states = states.duplicate()
