extends Node
class_name DialogueHelper

static var dialogue_box: DialogueBox
static var player: PlayerBase

static var dialogue_playing: bool = false
static var dialogue_sequence: Array[String] = []
static var dialogue_teller_name_sequence: Array[String] = []
static var dialogue_teller_portrait_sequence: Array[Texture2D] = []

static func is_dialogue_playing(): return dialogue_playing

static func set_player(_player: PlayerBase) -> void:
	player = _player
	dialogue_box = player.get_node("UI/DialogueBox")
	dialogue_box.action_pressed.connect(on_dialogue_box_action_pressed)
	play_demo_dialogue()
	
static func play_dialogue(
dialogue_id: String, 
dialogue_name: String = "", 
dialogue_portrait: String = "") -> void:
	play_dialogue_sequence([dialogue_id], [dialogue_name], [dialogue_portrait])

static func play_dialogue_sequence(
dialogue_ids: Array[String], 
dialogue_names: Array[String] = [], 
dialogue_portraits: Array[String] = []):
	player.restrict_movement()
	dialogue_box.show()
	dialogue_sequence.clear()
	for i in dialogue_ids:
		if dialogues_data.has(i):
			dialogue_sequence.append(dialogues_data[i])
	dialogue_teller_name_sequence = dialogue_names
	for i in dialogue_portraits:
		if portraits_data.has(i):
			dialogue_teller_portrait_sequence.append(portraits_data[i])
	play_dialogue_from_sequence()

static func play_dialogue_from_sequence() -> void:
	if dialogue_sequence.size() == 0:
		dialogue_box.hide()
		player.unrestrict_movement()
		return
	dialogue_box.clear_text()
	dialogue_box.set_text_slow(dialogue_sequence.pop_front())
	if dialogue_teller_name_sequence.size() > 0:
		dialogue_box.set_teller_name(dialogue_teller_name_sequence.pop_front())
	if dialogue_teller_portrait_sequence.size() > 0:
		dialogue_box.set_teller_portrait(dialogue_teller_portrait_sequence.pop_front())

static func play_demo_dialogue() -> void:
	play_dialogue_sequence(["demo_long_1"])

static func on_dialogue_box_action_pressed() -> void:
	if dialogue_box.slow_timer.is_stopped():
		play_dialogue_from_sequence()
	else:
		dialogue_box.show_all_text()

static var dialogues_data = {
	"demo_1": "Lorem ipsum dolor tahnum",
	"demo_2": "Hello opsum dolor offum tascum",
	"demo_long_1": "I'd say it depends; depends on whether you want an animation, whether you want collision shapes to change, etc.
You might end up using more than 1 technique to fully animate the entity
Matheff — Today at 1:52 PM",
}

static var portraits_data = {
	"unknown": preload("res://assets/sprites/portraits/unknown.png")
}
