extends Node
class_name DialogueHelper

static var dialogue_box: DialogueBox
static var fate_box: FateBox
static var player: PlayerBase

static var dialogue_playing: bool = false
static var dialogue_sequence: Array[String] = []
static var dialogue_teller_name_sequence: Array[String] = []
static var dialogue_teller_portrait_sequence: Array[Texture2D] = []
static var action_unabliness_timer: Timer

static var finish_funcs: Array[Callable] = []
static var icon_show_characters: Array[MovableCharacterBase] = []
static var icon_show_character_ongoing: MovableCharacterBase
static var keep_movement_restricted: bool = false

static func is_dialogue_playing(): return dialogue_playing

static func set_player(_player: PlayerBase) -> void:
	player = _player
	dialogue_box = player.get_node("UI/DialogueBox")
	dialogue_box.action_pressed.connect(on_dialogue_box_action_pressed)
	fate_box = player.get_node("UI/FateBox")
	action_unabliness_timer = player.get_node("ActionUnablinessTimer")
	QuestHelper.set_player(_player)
	play_demo_dialogue()
	
static func play_dialogue(
dialogue_id: String, 
dialogue_name: String = "", 
dialogue_portrait: String = "") -> void:
	play_dialogue_sequence([dialogue_id], [dialogue_name], [dialogue_portrait])

static func play_dialogue_sequence(
dialogue_ids: Array[String], 
dialogue_names: Array[String] = [], 
dialogue_portraits: Array[String] = []) -> void:
	dialogue_playing = true
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
	if icon_show_character_ongoing:
		icon_show_character_ongoing.hide_message_bubble()
		icon_show_character_ongoing = null
	if dialogue_sequence.size() == 0:
		dialogue_box.hide()
		if not keep_movement_restricted:
			player.unrestrict_movement()
		for f in finish_funcs:
			f.call()
		finish_funcs = []
		dialogue_playing = false
		action_unabliness_timer.start()
		dialogue_box.dialogue_finished.emit()
		return
	dialogue_box.clear_text()
	dialogue_box.set_text_slow(dialogue_sequence.pop_front())
	if dialogue_teller_name_sequence.size() > 0:
		dialogue_box.set_teller_name(dialogue_teller_name_sequence.pop_front())
	if dialogue_teller_portrait_sequence.size() > 0:
		dialogue_box.set_teller_portrait(dialogue_teller_portrait_sequence.pop_front())
	if icon_show_characters.size() > 0:
		icon_show_character_ongoing = icon_show_characters.pop_front()
		icon_show_character_ongoing.show_message_bubble()

static func set_state_upon_finish(key: String, value: Variant) -> void:
	add_finish_func(func(): StateHelper.sets(key, value))

static func play_demo_dialogue() -> void:
	play_dialogue_sequence([])

static func on_dialogue_box_action_pressed() -> void:
	if dialogue_box.slow_timer.is_stopped():
		play_dialogue_from_sequence()
	else:
		dialogue_box.show_all_text()

static func dummy() -> void:
	pass

static func add_finish_func(finish_func: Callable):
	finish_funcs.append(finish_func)

static func set_up_fate(left_text: String, right_text: String, texture: Texture2D,
left_outcome_func: Callable, right_outcome_func: Callable):
	start_cutscene_set_up()
	fate_box.fate_chosen.connect(stop_cutscene_set_up, CONNECT_ONE_SHOT)
	fate_box.left_chosen.connect(left_outcome_func, CONNECT_ONE_SHOT)
	fate_box.right_chosen.connect(right_outcome_func, CONNECT_ONE_SHOT)
	fate_box.play_fate(left_text, right_text, texture)

static func start_cutscene_set_up() -> void:
	QuestHelper.hide_quests()
	keep_movement_restricted = true
	player.restrict_movement()

static func stop_cutscene_set_up() -> void:
	QuestHelper.show_quests()
	keep_movement_restricted = false
	player.unrestrict_movement()
	player.get_node("Camera2D").offset = Vector2.ZERO

static var dialogues_data = {
	"demo_1": "Lorem ipsum dolor tahnum",
	"demo_2": "Hello opsum dolor offum tascum",
	"demo_long_1": "I'd say it depends; depends on whether you want an animation, whether you want collision shapes to change, etc.
You might end up using more than 1 technique to fully animate the entity
Matheff — Today at 1:52 PM",
	"demo_10": "Dialogue number 1 with text",
	"demo_11": "Dialogue number 2 with text",
	"demo_12": "Dialogue number 3 with text ",
	
	"general_sigh": "*Sighs*",
	
	"story_1": "Arising from a deep slumber, the Sacred Capybara, of whom many legends have been told, opens their eyes.",
	"story_2": "You find yourself stranded in an unknown land. Every time you wake up, you find yourself in a different place.
	Maybe it is the space-time itself that transports you to a different location each time, or maybe you unknowingly wander during your sleep by your feet.
	It doesn't need to be known, for it is for the better that you can travel far away in a brief moment of unconscious sleep.",
	"story_crystal_orange_1": "You see a bizarre crystal before you.",
	"story_crystal_orange_2": "Its colors remind you of the shade of your skin. But does it actually matter?",
	
	"evil_snake_1": "I can't believe my eyes! It's a Sacred Capybara standing in front of me!",
	"evil_snake_2": "So... I am a lovely snake. Yeah. I have an apple tree growing here. But noone comes here :(.
	Would you mind to taste some apples? I would really like it.",
	"evil_snake_2*": "Go and taste the apple, honey :)",
	"evil_snake_3": "It's so good that someone has finally tasted my apples! They taste very good, right? :)",
	"evil_snake_left": "The snake had gone. You see no trace of it.",
	"evil_snake_prophecy_1": "
		It shall be said for ages last:
		When capybara marches past
		And snake's ingenious deceit
		Makes capybara eat the treat
		Then Lance's chains will break apart
		And world would soon come to a halt",
	"evil_snake_prophecy_1_think": "You wonder about the meaning of this text.",
	"evil_snake_cave_1": "You see a note lying on the cave floor:",
	"evil_snake_cave_2": "I'm writing this as I'm waiting for my death to come. We are trapped here. No one wil come to help us.
	I have been praying to everyone that I know for these past days. To the Holy Ferret, to the Sacred Capybara, to the Three Guardians.
	The barrier is in place, and there's no other way out. Our elder, Samar, has gone to make an inscribing. He said that he must do that while he is still alive.
	I don't understand what he's gonna write on the wall and why he does that, but I didn't stop him.
	If anyone is reading this, please tell my wife, Julia, who lives in the nearby village, that I love her much.",
	
	"getting_dark_1": "It is starting to get dark already.",
	"getting_dark_2": "But haven't you just woken up?",
	
	"village_intro_1_1": "Timmy, go back hom! It's night already.",
	"village_intro_2_1": "Mom! I still want to play, it's fine! Please!",
	"village_intro_1_2": "Go back home, or Sacred Capybara will come for you and eat you alive!",
	"village_intro_2_2": "OK, mom.",
	"village_intro_2_3": ";(",
	
	"village_angered_mom_1": "Hey, where did you come from? I didn't know that clowns live in the west mountains.
	Oh. Wherever you got your costume from, at least the kids will go to their homes quicker.",
	
	"timmy_house_overhear_1": "You overhear voices coming from a window.",
	"timmy_house_overhear_2": "So, kids, here's the story for a night:
	In a distant kingdom, over the ocean, far away, lives Sacred Capybara. The Capybara's ways are but unknown, and yet there are people who struck upon it.
	Once a man was hunting in a forest, and from a thin air the Capybara appeared. And in a spare second, animals started appearing out of nowhere.
	The Capybara's eyes were giving away fulgent light, so intense, that the man almost blinded himself when he looked at the Capybara.
	The man fell onto his knees and started begging for forgiveness. Then, the Capybara started growing bigger and bigger.
	After a minute, it was as big as a mountain. Then, it disappeared.",
	"timmy_house_overhear_3": "Sacred Capybara favors those who worship it, and maliciously kills all heretics that stand in its way.
	Now, kids, sleep.",
}

static var portraits_data = {
	"unknown": preload("res://assets/sprites/portraits/unknown.png")
}
