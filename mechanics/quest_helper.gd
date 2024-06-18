extends Node
class_name QuestHelper

static var player: PlayerBase
static var quest_box: QuestBox

static var quest_texts: Array[String] = []
static var quest_colors: Array[Color] = []

static func set_player(_player: PlayerBase) -> void:
	player = _player
	quest_box = player.get_node("UI/QuestBox")
	add_quest("Demo Quest", 3)
	player.get_tree().create_timer(4).timeout.connect(
		func():
			remove_quest("Demo Quest", 3)
	)
	poll_quests()

static func add_quest(quest_name: String, notifier_time: int = 10) -> void:
	quest_box.add_quest_notified(quest_name, notifier_time)

static func remove_quest(quest_name: String, notifier_time: int = 10) -> void:
	quest_box.remove_quest_notified(quest_name, notifier_time)

static func poll_quests() -> void:
	for quest in quest_box.quests:
		if quest_funcs.has(quest):
			var func_to_call: Callable = quest_funcs[quest]
			func_to_call.call()
			quest_box.set_quest_items(quest, quest_texts, quest_colors)

static var quest_funcs = {
	"Demo Quest": poller_demo_quest
}

static func poller_demo_quest() -> void:
	quest_texts = ["Line 1", "Line 2", "Line 3"]
	quest_colors.resize(3)
	quest_colors.fill(Color.AQUA)
