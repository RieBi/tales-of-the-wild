extends CanvasLayer
class_name QuestBox

@onready var tree: Tree = $Tree
var root: TreeItem

var quests = {}

func _ready() -> void:
	root = tree.create_item()

func add_quest(quest_name: String) -> TreeItem:
	var new_quest = tree.create_item(root)
	new_quest.set_text(0, quest_name)
	new_quest.set_custom_color(0, Color.CORNFLOWER_BLUE)
	quests[quest_name] = new_quest
	return new_quest

func remove_quest(quest_name: String) -> void:
	var quest_to_remove: TreeItem = quests[quest_name]
	root.remove_child(quest_to_remove)
	quests.erase(quest_name)

func add_quest_notified(quest_name: String, time_to_notify: int = 10) -> void:
	var new_quest = add_quest(quest_name)
	var old_text = new_quest.get_text(0)
	new_quest.set_text(0, "[NEW] " + old_text)
	get_tree().create_timer(time_to_notify).timeout.connect(
		func():
			new_quest.set_text(0, old_text)
	)

func remove_quest_notified(quest_name: String, time_to_notify: int = 10) -> void:
	var quest_to_remove: TreeItem = quests[quest_name]
	var old_text = quest_to_remove.get_text(0)
	quest_to_remove.set_text(0, "[COMPLETED] " + old_text)
	get_tree().create_timer(time_to_notify).timeout.connect(
		func():
			remove_quest(quest_name)
	)

func set_quest_items(quest_name: String, items: Array[String], colors: Array[Color]) -> void:
	var quest: TreeItem = quests[quest_name]
	for i in quest.get_children():
		quest.remove_child(i)
	for i in range(items.size()):
		var item = tree.create_item(quest)
		item.set_text(0, items[i])
		item.set_custom_color(0, colors[i])
