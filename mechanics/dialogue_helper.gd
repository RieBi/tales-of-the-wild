extends Node
class_name DialogueHelper

static var dialogue_box: DialogueBox

static var dialogue_playing: bool = false
static var dialogue_sequence: Array[String] = []

static func is_dialogue_playing(): return dialogue_playing

static func set_player(player: PlayerBase) -> void:
	dialogue_box = player.get_node("UI/DialogueBox")
	dialogue_box.slow_ended.connect(play_dialogue_from_sequence)
	play_demo_dialogue()
	
static func play_dialogue(dialogue_id: String) -> void:
	play_dialogue_sequence([dialogue_id])

static func play_dialogue_sequence(dialogue_ids: Array[String]):
	dialogue_sequence.clear()
	for i in dialogue_ids:
		dialogue_sequence.append(dialogues_data[i])
	play_dialogue_from_sequence()

static func play_dialogue_from_sequence() -> void:
	if dialogue_sequence.size() == 0:
		return
	dialogue_box.clear_text()
	dialogue_box.set_text_slow(dialogue_sequence.pop_front())

static func play_demo_dialogue() -> void:
	play_dialogue_sequence(["demo_1", "demo_2"])

static var dialogues_data = {
	"demo_1": "Lorem ipsum dolor tahnum",
	"demo_2": "Hello opsum dolor offum tascum",
	"demo_long_1": "I'd say it depends; depends on whether you want an animation, whether you want collision shapes to change, etc.
You might end up using more than 1 technique to fully animate the entity
Matheff — Today at 1:52 PM",
}
