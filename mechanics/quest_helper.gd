extends Node
class_name QuestHelper

static var player: PlayerBase
static var quest_box: QuestBox

static var quest_texts: Array[String] = []
static var quest_colors: Array[Color] = []

static var STR_COMPLETED := "[COMPLETED] "

static func set_player(_player: PlayerBase) -> void:
	player = _player
	quest_box = player.get_node("UI/QuestBox")
	

static func add_quest(quest_name: String, notifier_time: int = 10) -> void:
	quest_box.add_quest_notified(quest_name, notifier_time)
	poll_quests()

static func remove_quest(quest_name: String, notifier_time: int = 10) -> void:
	quest_box.remove_quest_notified(quest_name, notifier_time)
	poll_quests()

static func poll_quests() -> void:
	for quest in quest_box.quests:
		if quest_funcs.has(quest):
			var func_to_call: Callable = quest_funcs[quest]
			func_to_call.call()
			if quest_colors.size() != quest_texts.size():
				quest_colors = create_text_colors(quest_texts)
			quest_box.set_quest_items(quest, quest_texts, quest_colors)

static func hide_quests() -> void:
	quest_box.hide()

static func show_quests() -> void:
	quest_box.show()

static func create_text_colors(texts: Array[String], due_color: Color = Color(0.7, 0.7, 0.7)) -> Array[Color]:
	var colors: Array[Color] = []
	for t in texts:
		if t.begins_with(STR_COMPLETED):
			colors.append(Color.WEB_GREEN)
		else:
			colors.append(due_color)
	return colors

static var quest_funcs = {
	"Demo Quest": poller_demo_quest,
	"Capybara Jones": poller_capybara_jones,
	"Stranger Sticks": poller_stranger_sticks,
}

static func poller_demo_quest() -> void:
	quest_texts = ["Line 1", "Line 2", "Line 3"]
	quest_colors.resize(3)
	quest_colors.fill(Color.AQUA)

static func poller_capybara_jones() -> void:
	var texts: Array[String] = ["Make your way to the temple"]
	var temple_state = StateHelper.gets("lucas_temple")
	if temple_state > 0:
		texts[0] = STR_COMPLETED + texts[0]
		texts.append("Solve the puzzle")
	if temple_state > 1:
		texts[1] = STR_COMPLETED + texts[1]
		texts.append("Explore the inner temple")
	if temple_state > 2:
		texts[2] = STR_COMPLETED + texts[2]
		texts.append("Eradicate the evil in the crypt")
	if temple_state > 3:
		texts[3] = STR_COMPLETED + texts[3]
		texts.append("Talk with Pig Brother")
	
	quest_texts = texts
	
static func poller_stranger_sticks() -> void:
	var stick_count = StateHelper.gets("sticks_collected")
	var texts: Array[String] = ["Gather sticks (%s / 5)" % stick_count]
	if stick_count == 5:
		texts[0] = STR_COMPLETED + texts[0]
		texts.append("Talk with Asedine")
	
	quest_texts = texts
