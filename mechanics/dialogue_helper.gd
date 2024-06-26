extends Node
class_name DialogueHelper

static var dialogue_box: DialogueBox
static var fate_box: FateBox
static var acqusition_box: AcquisitionBox
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
	acqusition_box = player.get_node("UI/AcquisitionBox")
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

static func set_up_acquisition(item_text: String, item_texture: Texture2D) -> void:
	start_cutscene_set_up()
	acqusition_box.item_taken.connect(stop_cutscene_set_up, CONNECT_ONE_SHOT)
	acqusition_box.play_item(item_text, item_texture)

static func start_cutscene_set_up() -> void:
	QuestHelper.hide_quests()
	keep_movement_restricted = true
	player.restrict_movement()

static func stop_cutscene_set_up() -> void:
	QuestHelper.show_quests()
	keep_movement_restricted = false
	player.unrestrict_movement()
	player.get_node("Camera2D").offset = Vector2.ZERO
	action_unabliness_timer.start()

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
	
	"story_1": "Arising from a deep slumber, the Sacred Capybara, of whom many legends have been told, opens their eyes. [Press SPACE to continue dialogues]",
	"story_2": "You find yourself stranded in an unknown land. Every time you wake up, you find yourself in a different place.
	Maybe it is the space-time itself that transports you to a different location each time, or maybe you unknowingly wander during your sleep by your feet.
	It doesn't need to be known, for it is for the better that you can travel far away in a brief moment of unconscious sleep.",
	"story_crystal_orange_1": "You see a bizarre crystal before you.",
	"story_crystal_orange_2": "Its colors remind you of the shade of your skin. But does it actually matter?",
	"story_undone_1": "You feel like you aren't done yet with the alcove to the North.",
	
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
	
	"village_intro_1_1": "Timmy, go back home! It's night already.",
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
	
	"lucas_1": "Wow! Is it really you? The Sacred Capybara? I remember every story about you that I've heard! But not of them are true, right?
	Have you ever met the Holy Ferret? Did you really fight the Black Mermaid? Nervermind. I'm so glad to meet you!",
	"lucas_2": "My parents always say that I shouldn't stay outside so late. I hope they won't find me here.
	I love to go and explore the forest to the north of here. Recently, I found a weird structure, it looks almost like a temple.
	I've tried to go further, but I couldn't find a way to do it. It seems like there's some sort of a puzzle.
	Come on, help me with it :D",
	"lucas_3": "Look at the tunnels, there's something in them. Maybe that will help to solve it?",
	"lucas_4": "Wow! You managed to open the door. Unfortunately, it's almost night now. I have to go home.",
	"lucas_5": "See you tomorrow, Capybara!",
	"lucas_stuck": "I see you are getting trouble solving this. So am I. I think, the two bottom ones should be turned to the right to solve it.",
	
	"pig_1_1": "Greetings, unpig! We haven't seen unanimalists here since we expelled humans from here.
	Since then we were living a plusgood life here. It just that recently we've got a problem. But that's not a big trouble!",
	"pig_1_2": "Long live the Pig Brother!",
	"pig_1_truth": "With the food shortage gone, we decided to expand our territories. Soon the whole world would be under our control!",
	"pig_1_lie": "Oink! Oink oink oink!!!",
	"pig_2_1": "Who is you? Go talk with Pig Brother. He needs you help. I enjoy doubleplusgood life here. I is very sane here. No trouble me. I hungerful.
	You go help. Who is you? Go talk with Pig Brother. He needs you help. I enjoy doubleplusgood life here...",
	"pig_2_2": "The pig seems to be repeating the same words over and over again.",
	"pig_2_truth": "I enjoyed doubleplusgood life here before. I enjoy tripleplusgood life now.",
	"pig_2_lie": "Oink! Doubleoink! Oink oink.",
	"pig_3_1": "The pig appears to be sleeping. You hear indistinct mumbles coming from its mouth:",
	"pig_3_2": "Down with brothr! Dwn with brthr! Down wth brther!",
	"pig_3_truth": "Hail the Mastr! Hl th Mastr! Hail th Mster!",
	"pig_4_1": "I was trying to come up with the new version of pigspeak all day long, but the hunger makes it unpossible to do.
	I guess we will have to stick with the old version for now.",
	"pig_4_2": "By the way, do you think unold should be the opposite of old, or unyoung be the opposite of young? Ah, nevermind, I'll figure that out once we get food.",
	"pig_4_truth": "Thanks to brave actions of Pig Brother, we now have doubleplusplenty of food. The new pigspeak dictionary is almost done!",
	"pig_4_lie": "Oink. Knio. Oink. Knio.",
	"pig_5_1": "Ahoy, unpig! I'm guarding the door. Since our fellow comrade pig disappeared in the crypt, we close the door.
	We are plusafraid to go there. We hear plusbad screams during undays coming from the crypt. I'll open it if Pig Brother says so.",
	"pig_5_2": "Please, go talk to Pig Brother! I miss blueberries so much! I haven't eaten one for days now. My stomach hurts.
	Noone else wanted to eat them, so I was doing it all day long.",
	"pig_5_3": "Finally! I've opened the door. Go and kill what lurks there, whatever it might cost you!",
	"pig_5_truth": "Since Pig Brother eradicated all evil in the crypt, I've been administered to serve in the Pignistry of food.
	Now, I deprive the pigs who commit thought crime of food. Everyone is living even goodlier now.",
	"pig_5_lie": "Oink? OINK? OINK OINK OINK?",
	"pig_6_1": "How's you doing, comrade unpig? Did you know that we've grown 718 bananas today, which is 20 times more than we did untomorrow,
	and twice as much as was planned? We live goodlier and goodlier every day. I'm so happy to serve the Pig Brother.",
	"pig_6_2": "I may not be fed, but it's just because all other pig comrades need bananas more than me.
	I am willing to be hungry so that others can live doubleplusgood life. Long live the Pig Brother!",
	"pig_6_truth": "Long live Pig Brother, comrade unpig! Did you know that every pig is having 1 banana per day now,
	which is a hundred times more than untomorrow, and 5 times as much as was planned?",
	"pig_6_lie": "Oink. 5 oink. 7 oink. OINK!",
	"pig_7_1": "I guard the Pig Brother. I have always guarded the Pig Brother. He has always been the Pig Brother.
	Since the old guard pig refs unperson, I have always guarded the Pig Brother. Forever. I will do so.
	I am the only one who ever guarded the Pig Brother. It's hard to guard when you unfed. I have never been hungry.
	I have always been fed. I am not hungry. Never been so.",
	"pig_7_2": "Long live the Pig Brother!",
	"pig_7_lie": "Oink... MEOW?",
	"pig_8_1": "What are you? A rug? You is big for a rug. Anyway, I am the Pig Brother, and you obey me. You have always obeyed me.
	The only thing you have done in your life is obeyed me. Now, go into the crypt and eradicate all evil. You may as well tell the guard to open the door.",
	"pig_8_2": "You. Have. Always. Obeyed. Me. And will do so. Forever.",
	"pig_8_3": "Long live me!",
	"pig_8_truth": "I am watching you. I have always watched you. I will always do. You will obey me. You have always obeyed me.
	You will always do. Here's a red key for obedience.",
	"pig_8_lie": "So there's no food left? We no longer can live here then. We will have to return to humans now. There's no other choice.",
	"pig_8_lie_key": "If that's so, we no longer need the key that we were keeping. You can take it.",
	"pig_8_lie_2": "Oink ;(",
	"pig_big_1": "Who are you? How did you get here? It's so good just to lie here and eat all the food. Just me. No Pig Brother.
	No other pigs. Noone can stop me from eating. It was such a good idea to start screaming after they sent me to get more food.
	Those pigs are as stupid as a lumber log. They think that something dangerous haunts these crypts. They've all gone mad with the Pig Brother.",
	"pig_big_2": "So it's the Pig Brother who sent you here? You know what? Go and tell him that you found my dead body and all the food disappeared.
	Say that there's blood everywhere around here and god knows what can be lurking here. That way, I can enjoy eating all the food forever ;)",
	"pig_watching": "Pig Brother is watching you.",
	"pig_master_watching": "I am watching you.",
	"pig_prop_scroll_1": "Hunger is satiation.
	Emptiness is fullness.
	Sadness is happiness.",
	"pig_prop_note_1": "Ignorance is strength.",
	"pig_prop_note_2": "Freedom is slavery.",
	"pig_prop_book_1_1": "You see a bunch of books in the bookcase. One of them says:",
	"pig_prop_book_1_2": "Ten indomitable virtues of Pig Brother",
	"pig_prop_book_2_1": "The bookcase is filled with copies of one book: 'Three Easy Steps to an All-New You'.",
	"pig_prop_book_2_2": "On one of the book covers, you see a text written with black marker: 'Secure, Contain, Protect'.",
	"pig_prop_crystal_violet_1": "You see a strange crystal in front of you.",
	"pig_prop_crystal_violet_2": "Its colors remind you of the shade of a... sheep. Are sheep actually violet?",
	"pig_prop_coins": "It's just a bunch of coins. On all of them there is an engraved portrait of a pale man.
	Underneath the portrait, it says: 'Liber, the King'",
	"pig_prop_bed_1": "A comfy bed.",
	"pig_prop_bed_2": "Upon closer inspection, you see a bunch of bugs crawling around it.",
	"pig_prop_sign_crypt": "Food are there.",
	"pig_crypt_1": "Walking down the corridor, you hear nothing. No screams, nothing. Yet it's night. That's strange, isn't it?",
	"pig_crypt_2": "You have a weird feeling in your nose. Is it a peach? A banana? Ananas? No, that's a pineapple. Or is it?",
	"pig_crypt_gin": "You see many bottles of muddy liquid. On the bottle label, it says: 'Victory gin'.",
	"pig_crypt_sign_1": "The sign reads: 'Heaven'.",
	"pig_crypt_sign_2": "That's strange. It points to a blank wall.",
	"pig_crypt_inscribing": "You see an inscribing on the floor. It says: 'Monkey King was here'.",
	"pig_crypt_dragons": "Eternal battle of the two dragons.",
	
	"follower_thomas_1": "Finally, you are here! We've been waiting for you arrival for many years. There's only a few things left to do,
	and we will be able to begint the ceremony. You can feel like you are home here, Sacred Capybara. When you're ready,
	talk to our leader, Asedine. She's a mage, so you will quickly identify her.",
	"follower_thomas_2": "Since I learnt the teachings of Sacred Capybara, ergo your teachings, I never shaved my beard.
	It's quite big now, since it was a long time ago. And yet, I was faithful to you for the whole time.",
	# FATE is here
	"follower_thomas_3": "I always wanted to ask you, and now I'm given the chance, but I'm... ah, it might be the only chance.
	So, do you prefer pineapples on pizzas or pizzas on pineapples?",
	"follower_thomas_fated": "Really? Never thought that Sacred Capybara is such a weirdo.",
	"follower_sergio_1": "I might be old, by I still remember the Capybara style of Bung-Du.
	I would have given you a nice beating, if it wasn't the aching back.",
	"follower_sergio_2": "Oh, wait, let my open my eyes.",
	"follower_sergio_3": "Believe me or not, I see Sacred Capybara in front of me. Can you imagine, even my eyes betray me now.
	Ah, if only I had a way to become young again.",
	"follower_sergio_4": "Wait, you know what? You would always hear the peasants tell bloody stories of Sacred Capybara, but those are no more than lies.
	It is well known that Sacred Capybard was once a member of Guardian Order, before it was disbanded. My grandpa told it to me.
	Or was it grandgrandpa? Ah, I bet he was older at the time than I am now. So, where did I stop?",
	"follower_sergio_5": "Oh, yeah. Guardian Order was disbanded and the five higher members of it parted their ways.
	Since then, every human must pray to The Three Guardian at least once a day. Otherwise, a great evil awaits those who dare not to.
	We owe everything to The Three Guardians. If not them, the world would a place for no men to live.",
	"follower_isolde_1": "You see those flowerbeds? I've been learning to grow them since I was a child.
	The blue ones, on the right, are the most difficult to grow. A legend says these flowers were once pure black, and staring at them for a few seconds would sink your sould into void.
	But after you, Capybara, fought the Black Mermaid, and launched its hideous tail into oblivion, a curse was lifted,
	and the flowers turned into charming blue color, as they are now. Is the story true? Did you really fight Black Mermaid?",
	"follower_isolde_2": "Pardon me if I'm too insistive, it's a great honor for me to meet you. By the way, the blue flowers
	are called marmaids. Yes, marmaids, and not mermaids, like most people tend to think. They even have magic properties.
	If you carry these flowers onto the peak of a mountain during full moon at the eighth month of year on second day of week
	during a rainy day after the mist had fallen and birds went to sleep and a hawk catches a mouse right at the edge of an ocean
	after a shark eats two teaspoons of salt covered in a weak mold only then to fold its tail and sing a song of seven heirs,
	and sky turns red after a king dies due to being stabbed by bayonet, and a chalice of blood is drinked by a rat,
	and a snake bites me after I play clarinet...",
	"follower_isolde_3": "Oops, did I say snake? I meant to say python. Not Monty Python, but just a regular python. You know, they are very different.
	So, when all of that happens and you bring marmaids to the peak of a mountain, nothing abnormal happens. Can you imagine that?
	It's so intruiging! I wish I had a chance to try it one day. Till then, I wouldn't be able to consider myself a gigachad.",
	# CUTSCENE bullshittery
	"follower_olaf_1": "Hey ya, pokemon! Oh, you are not a pokemon, you are Sacred Capybara, the one we've been waiting for during all these years?
	That's for the better. Have you already talked with Sergio? The old man's sight might be gone, but his vision holds true.
	It's thanks to him that I could learn the art of Khan-Ku. Or was it Kung-Fu? Or Tsan-Mu? I can't ever remember that name.
	Yet, it doesn't prevent me from practicing it. I've learnt a lot of stuff already, but there's still much more to learn.
	Here, I'll show you my technique.",
	"follower_olaf_2": "Holdin' me back.
	Gravity's holdin' me back.",
	"follower_olaf_3": "And now I'm smooth like butter.",
	"follower_olaf_4": "Like a criminal undercover.",
	"follower_olaf_5": "Like a real Pablo Escobaro.",
	"follower_olaf_6": "Well, I'm done for now. See ya later, Alligator!",
	"follower_asedine_1": "My crystal ball that I hold in my camp has told me of your arrival. By the name of The Three Guardians,
	you shall serve your mission.",
	"follower_bondurnar_1": "It's a good day for berrying, ain't it?",
	"follower_bondurnar_2": "Don't you freak out, you crazy! Name's Bondurnar. The last of the dragons.
	I may not look like like a dragon, but deep down in my soul, I am. I can even breath fire!",
	# fire particles
	"follower_bondurnar_3": "If only I had wings, I would travel through the whole world. I would visit all the realms. Nothing would stay out of my sight!
	But right now, I am here. Growing in front of you, stopping you from moving farther before you meet all of us and talk with Asedine.",
	"follower_bondurnar_4": "You know what? I don't believe any of the nonsense that Asedine is preaching. If there's anything special in this world, it ain't you.
	You look like a typical capybara.",
	"follower_bondurnar_5": "*Sniffs*",
	"follower_bondurnar_6": "You smell like a typical capybara. And I don't need to touch you to know you're a typical capybara.
	Oh, may I turn red if there's something special about you.",
	# turns red
	"follower_bondurnar_7": "You see? I'm still as green as you are. Nothing special about ya. Not a tad bit.
	If you wonder why I joined the followers of sacred capybara, it's because Olaf has quite a lot of poop hidden in his camp, believe it or not.
	Did I say poop? NOPE! It's a golden quality fertilizer. That's what makes by berries taste so sweet. Wanna try one?
	Anyway, I'm not moving till Asedine tells me to.",
	"follower_asedine_2": "Now, acquaint yourself with all the other followers, and we will be able to proceed",
	"follower_asedine_3": "Great, you are now familiar with who we are. The ceremony is almost about to begin, but we've got a...
	sticky problem. You see, the ceremony needs a burning campfire. Such are the rules. It was not me who wrote them.
	WELL, techincally it was me <3. Yet, we will omit that in the current situation. You shall find 5 good sticks that will burn well.
	We've got a nice looking forest to the right of the camp, I'm pretty sure there are lots of sticks lying on the ground in it.
	Finding 5 sticks would be a piece of cake for such a honey like you <3",
	"follower_asedine_4": "You have brought all the sticks? THE CEREMONY SHALL BEGIN.",
	
	"follower_stick_1": "You see a stick. You put it in your capypocket.",
	"follower_stick_2": "You see a stick. It's covered in ketchup. Yummy!. You lick all the ketchup off of it and pick up the stick.",
	"follower_stick_3": "A boomerang-shaped stick. Or a stick-shaped boomerang. You better pick it up, or it will haunt you in your dreams.
	And so you do.",
	"follower_stick_4": "You see a sacrifice plate, ready to be filled with blood of heretics. You feel like it could burn really well in the campfire.",
	"follower_stick_5": "You see a string of Unicode-16 symbols. Mostly escape sequences. Not much usage. Yet it could burn well. You pick it up.",
	"follower_help_1": "Looking up, you see a call for HELP. You think about who could have built it.",
	"follower_help_2": "You thought well. And yet you have no idea who's behind this.",
	"follower_wrong_passage_1": "There's nothing in here. Absolutely nothing. A pure void. Or is there?",
	# A void appears
	"follower_wrong_passage_2": "A void of mesmerizing beauty appears. You can't restrain yourself from looking at it.",
	# Void starts staring back (eyes appear)
	"follower_wrong_passage_3": "The void lookes back at you. Could it be love?",
	
	"ceremony_1_asedine": "EVERYONE TO THEIR PLACES! THE CEREMONY BEGINS NOW!",
	# Everyone gets to their places
	"ceremony_2_asedine": "Dear Brothers and Sisters. Thank you for coming. It has been an age since last we were at the ceremony.
	I am sorry to pull you from your affairs, but this is a matter that cannot wait. Sacred Capybara has arrived.
	And thus shall we say:",
	"ceremony_3_asedine": "
	We've prayed for ages to the gods
	Our acts were all yet met undone
	We were giving sober nods
	And nothing came out of this satire",
	"ceremony_4_thomas": "From dawn till dusk we smiled to heavens
	This was the only thing to do
	We never looked at evil caverns
	Though evil snake wanted us to",
	"ceremony_5_sergio": "The day we met was blooming yellow
	The shade of pale skin and demise
	Our old plans were only shallow
	For we could not yet recognize",
	"ceremony_6_isolde": "A day will come to battle evil
	Which lurks in everyone of us
	The Capybara's mind will shiver
	All of the knowledge it did amass",
	"ceremony_7_olaf": "We shall give key to open gates
	Whether they lead to sun or dust
	We can't abandon our fates
	And Capybara must go fast",
	"ceremony_8_bondurnar": "Here, take your key.",
	
	"follower_asedine_end": "Farewell, Capybara, may The Three Guardians be with you!",
	"follower_thomas_end": "May pineapples be with you!",
	"follower_sergio_end": "I still haven't quite understood, are you the real Sacred Capybara, or was it just a preparation ceremony?",
	"follower_isolde_end": "I'll put up a new flowerbox in memory of you!",
	"follower_olaf_end": "My Shao Bin skills will continue to rise, and one day I might as well be just like you.",
	"follower_bondurnar_end": "Mhm? I'm just bushing out here, no need to stare at me like that.",
	
	"rg_door_no_rg": "The door needs red and green key to open. You don't have any of those.",
	"rg_door_no_r": "You have the green key, but this door also needs the red key to open the door.",
	"rg_door_no_g": "You've got the red key, but you lack the green one to open the door.",
	"rg_door_open": "You put both of the keys into the door. The door opens.",
	
	"shut_door": "The door is locked shut. It has three keyholes in it.",
	"ceo_1": "Greetings! I am the CEO of MoneyCorp.",
	"ceo_2": "I've got a little bit of gold, but it's not enough. Way too little. My plan is to make an infinite amount of
	money per year for an infinite amount of years, while also increasing my profits by ∞% every quarter. Would I have enough money after that?",
	"ceo_3": "Nope, I don't think so. Need even more. The line must go up. I need to rethink the work conditions of my workers.",
	"ceo_4": "They would need to work at least 25 hours a day, and if they don't want to get a paycut, then at least 48 hours a day.
	Of course, they must also work at least 8 days a week. That would be a bare minimum. Their annual leave should be at most -20 days.
	That is, 20 days per year they work even harder, working 2 days a day every day. They would handle it. We're a family, after all.",
	"ceo_5": "That is the only way.",
	
	"finalle_sleepy_1": "You feel sleepy. Maybe it's the time to go to bed?",
	"finalle_sleepy_2": "You feel REALLY sleepy. You can barely walk now.",
	
	"eater_intro_1": "You wake up feeling a strong rancid stench in your lungs.",
	# wake up
	"eater_intro_2": "Opening your eyes, you see a fog of miasmas covering this destroyed village. What the hell had happened here?",
	"eater_body_1": "The boy is dead. Though the corpse is still fresh, it already started to rot pretty badly.",
	"eater_body_2": "A girl. Or rather it was a girl. The body parts are decimated so violently it is now difficult to recognize a human in it.",
	"eater_body_3": "It seems like this one was killed right as he stepped out the door of his house.",
	"eater_body_4": "He tried to hide behind the house. And yet it was futile. Whatever ravaged the village, it aimed to leave no life in it.",
	"eater_body_5": "One more body. Though you know that the thing that happened here is bad, you don't feel anything else but rancid stench permeating the air.",
	"eater_inscription_preamble": "You see a fresh text carved onto stone. The dust of it has still not settled out:
		'From the heavens the three guardians see war. But on earth, there is only carnage'",
	"eater_sign_1": "Here lies the prison to contain the damned king, Liber. Sentenced to eternity of containment for betraying The Three Guardians and all of humanity, he will face decay.
	Upon completion of this structure, it must be said that with wise actions of The Three Guardians, peace is restored in the world.
	And so it will be forever, for their power is immense, and evil is gone. This is the truth.",
	"eater_sign_2": "Carved out of twilight stone, the walls would stop any force that tries to break it.
	The prison will remain intact, no matter what is going outside of it.
	Forged out of adamantium in sunfire heat, infused with magic of The Three Guardians, and sealed with prophecies
	of higher members of Guardian Order, the chains are unbreakable. Not even the convolutions of space itself can rip it apart.
	They will slowly deprive Liber of power until, as the prophecies say, 1000 years in the future from now, Liber would be banished into the void and never come back, for out of the void there's no combing back.",
	"eater_sign_seals": "Here lies the hall of seals. Upon discretion of The Three Guardians, the higher members of Guardian Order
	have sealed the prophecy to come true. Each seal reinforces all other ones, and in tandem they'll banish Liber out of past and out of future, his existence in all times will he be gone.",
	"eater_seal_1": "The seal of Bear.",
	"eater_seal_2": "The seal of Capybara. Strange, isn't it? Was it actually you who sealed it?",
	"eater_seal_3": "The seal of Snake.
	
	Upon closer inspection, you can barely see that its magic is ever so slightly different from the other seals. How could it happen?",
	"eater_seal_4": "The seal of Ferret.",
	"eater_seal_5": "The seal of Werewolf.",
	"eater_liber_1": "The chains are broken in multiple places. Their shimmering glow is fading away. On the floor, you see a rough inscription carved into it:",
	"eater_liber_2": "
	In the black mayhem of disease
	I'm chained and covered in blood and dirt
	In agony I hold my furious tears
	And yet I know what was foretold
	My mind and will is safe, no fears
	Thousands of years pass in a moment
	For a mere human the aging kills
	And yet I am still only stolid
	In a mere happenstance of chance
	This knowledge I had always had
	A day will come for me to dance
	I will avenge them like a savage bat
	And then my destiny will be fulfilled
	I'll pour the carnage onto lands
	They'll fear my like they never feared
	And nothing would ever stop my plans",
	#END
	
	"abner_1": "Waking up, you feel a pleasant smell of rosy bloom in the air.",
	"abner_2": "Opening your eyes, you see a blooming garden of flowers surrounding you. The world shines bright.",
	"abner_jon_1": "Hello, Sacred Capybara! It's great to meet you! We all had a dream of you coming today. And here you are.
	Enjoy yourself in this place, you might as well call it heaven.",
	"abner_jon_2": "I've heard many stories of you, but I could never think I would meet you. And yet, here I am, talking with you.",
	"abner_jon_3": "Enjoy yourself :D",
	"abner_jelly_1": "No way, no way! The dream came true. Though these days were quite hectic, it's nice to have some rest today.",
	"abner_jelly_2": "We were celebrating the blossom of The Three Guardians, and then my grandpa, Julia, died.
	She was very old, and it is a great omen to die on the blossom day. I'm sure she's happy now in the afterlife.
	We were having a funeral yesterday, and then we've all got this dream of you coming. That's very interesting, isn't it?",
	"abner_jelly_3": "You can feel here like home.",
	"grave_1": "Austine, the onion warrior",
	"grave_2": "Mike, a good man and a great alcoholic",
	"grave_3": "Catherine, the sentinel of all animalists",
	"grave_4": "Julia, a great wife, woman, grandma, and caretaker of the myths",
	"grave_end_1": "On the other side of the grave slab, you see a text written all over it.
	Though the slab isn't that big by itself, when you look at it, it seems like it is expanding to fit all the tales of all the times that humanity has ever seen.
	There are tales of love, of hate, of war, of peace. There's a tale of Sacred Capybara, and its fight with Black Mermaid.
	Some of the tales are contradictory. For example, in one tale Sacred Capybara fights Black Mermaid and wins, setting the peace to the kingdom.
	In the other tale, Sacred Capybara befriends Black Mermaid to fight the evil together. Yet, neither of the story is worse due to this fact.
	In fact, all the stories just complements one another, and together they form this big, vivid ocean of thoughts and ideas that each one bears.",
	"grave_end_2": "When a person dies, its body becomes lifeless, but stories and memories that they made throughout their life lives past.
	It matters not if they are good or bad, they just persist. And one could argue that as long as the stories are not forgotten, the person is still alive.",
	"grave_end_3": "Looking closer at the top of the slab, almost fading into the surroinding air, one story captivates your mind:",
	"grave_end_4": "
	Once born a human, he didn't mean to die
	Caught in a whirlpool of all the truths and lies
	He marched past everything to ultimately meet the sky
	He met his divine powers like sun meets butterflies
	Liber's his name, of all the legends told
	The people of all casts met him with vivid joy
	He meant to end the slavery of very evil god
	But god's plans didn't quite align with Liber's ploy
	And once the rumor made its way of Liber's plans
	The god accused Liber that he betrayed the skies
	So all the servants rushed to gather all the clans
	And god took one of each to have on their sides
	Despite big Liber's power, god's influence took place
	A prison built in hours to cage the king was made
	Dark terror could be barely seen on empty Liber's face
	He knew that in few hours all of his life would fade
	Yet in stampede of rivals, there was elusive friend
	Not showing a tad bit of emotion, Snake had its sapient way
	Deceit is virtue of the Snake, and hence a rule be bent
	In the blind awe of other members, Snake used its fang
	And in a pristine way of doing, the prophecy could be undone
	Though unbeknown to god's endeavour, all seals were made futile
	In thousand years all Capybara's memories were meant to burn
	And Liber's chains would once come just to be a dark satire
	",
}

static var portraits_data = {
	"unknown": preload("res://assets/sprites/portraits/unknown.png")
}
