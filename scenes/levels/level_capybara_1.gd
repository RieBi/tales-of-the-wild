extends Node2D

var d: float = 0

func _process(delta: float) -> void:
	d = delta

func _on_awaken_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	hide()
	DialogueHelper.play_dialogue("story_1")
	DialogueHelper.add_finish_func(func():
		show()
		DialogueHelper.play_dialogue("story_2"))


func _on_crystal_trigger_action_done(_source: Area2D) -> void:
	DialogueHelper.play_dialogue_sequence(["story_crystal_orange_1", "story_crystal_orange_2"])


func _on_evil_snake_trigger_action_done(source: Area2D) -> void:
	match StateHelper.gets("evil_snake"):
		0:
			DialogueHelper.play_dialogue_sequence(["evil_snake_1", "evil_snake_2"])
			StateHelper.sets("evil_snake", 1)
			DialogueHelper.add_finish_func(func(): $Alcove/AppleTree/AppleTreeTrigger.process_mode = Node.PROCESS_MODE_INHERIT)
		1:
			DialogueHelper.play_dialogue("evil_snake_2*")
			source.hide()
		2:
			DialogueHelper.play_dialogue("evil_snake_3")
			source.hide()


func _on_apple_tree_trigger_action_done(_source: Area2D) -> void:
	match StateHelper.gets("evil_snake"):
		1:
			var red_apple_res = preload("res://assets/sprites/level1/red_apple.tres")
			var left_func = func():
				StateHelper.sets("evil_snake", 2)
				$Alcove/EvilSnake/EvilSnakeTrigger.show()
			var right_func = func():
				StateHelper.sets("evil_snake", 3)
				$Alcove/EvilSnake.queue_free()
				$Alcove/SnakeLeftTrigger.make_active()
			DialogueHelper.set_up_fate("eat", "leave", red_apple_res, left_func, right_func)
			$Alcove/AppleTree/AppleTreeTrigger.queue_free()



func _on_snake_left_trigger_action_done(_source: Area2D) -> void:
	DialogueHelper.play_dialogue("evil_snake_left")


func _on_inscribing_trigger_action_done(_source: Area2D) -> void:
	DialogueHelper.play_dialogue_sequence(["evil_snake_prophecy_1", "evil_snake_prophecy_1_think"])


func _on_cave_trigger_action_done(_source: Area2D) -> void:
	DialogueHelper.play_dialogue_sequence(["evil_snake_cave_1", "evil_snake_cave_2"])


func _on_getting_dark_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	var night_color = Color(0.508, 0.508, 0.508)
	var tween = create_tween()
	tween.tween_property(self, "modulate", night_color, 15)
	DialogueHelper.play_dialogue_sequence(["getting_dark_1", "getting_dark_2"])


func _on_first_cutscene_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	DialogueHelper.start_cutscene_set_up()
	var tween = create_tween()
	tween.tween_property($PlayerCapybara/Camera2D, "offset:x", 472, 3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	await tween.finished
	var timmy: MovableCharacterBase = $Village/Timmy
	var mom: MovableCharacterBase = $Village/AngeredMom
	DialogueHelper.icon_show_characters = [mom, timmy, mom, timmy, timmy]
	DialogueHelper.play_dialogue_sequence(
		["village_intro_1_1", "village_intro_2_1", "village_intro_1_2", "village_intro_2_2", "village_intro_2_3"],
		["Angered mom", "Timmy", "Angered mom", "Timmy", "Timmy"]
	)
	await DialogueHelper.dialogue_box.dialogue_finished
	timmy.start_moving()
	await timmy.path_finished
	timmy.queue_free()
	await create_tween().tween_interval(0.5).finished
	DialogueHelper.stop_cutscene_set_up()
	$Village/AngeredMom/AngeredMomTrigger.show()


func _on_angered_mom_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["village_angered_mom_1", "general_sigh"], ["Angered mom", "Angered mom"])
	await DialogueHelper.dialogue_box.dialogue_finished
	$Village/AngeredMom/AngeredMomTrigger.hide()


func _on_timmy_house_overhear_trigger_action_done(source: ActionTrigger) -> void:
	source.queue_free()
	DialogueHelper.play_dialogue_sequence(["timmy_house_overhear_1", "timmy_house_overhear_2", "timmy_house_overhear_3"],
	["", "Timmy's dad", "Timmy's dad"])


func _on_lucas_trigger_action_done(source: ActionTrigger) -> void:
	var lucas: MovableCharacterBase = $Village/Lucas
	match StateHelper.gets("lucas_temple"):
		0:
			DialogueHelper.play_dialogue_sequence(
				["lucas_1", "lucas_2"], ["Lucas", "Lucas"]
			)
			await DialogueHelper.dialogue_box.dialogue_finished
			QuestHelper.add_quest("Capybara Jones")
			source.hide()
			lucas.start_moving()
			await lucas.path_finished
			source.show()
		1:
			DialogueHelper.play_dialogue("lucas_3", "Lucas")
			source.hide()


func _on_temple_entrance_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	StateHelper.sets("lucas_temple", 1)


func _on_temple_puzzle_solved() -> void:
	StateHelper.sets("lucas_temple", 2)
	QuestHelper.poll_quests()
	var tilemap: TileMap = $TileMap
	tilemap.set_cell(0, Vector2(116, -40))
	$Village/Lucas/LucasTrigger.hide()
	
	var lucas = $Village/Lucas
	var lucasPath2 = $Village/LucasPath2/PathFollow2D
	DialogueHelper.start_cutscene_set_up()
	DialogueHelper.play_dialogue_sequence(["lucas_4", "lucas_5"], ["Lucas", "Lucas"])
	lucas.show_message_bubble()
	await DialogueHelper.dialogue_box.dialogue_finished
	lucas.hide_message_bubble()
	lucas.speed *= 2
	lucas.set_path(lucasPath2)
	DialogueHelper.stop_cutscene_set_up()
	await lucas.path_finished
	lucas.queue_free()


func _on_pig_1_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		5:
			DialogueHelper.play_dialogue_sequence(["pig_1_truth", "pig_watching"], ["Pig", "Pig Brother"])
			source.hide()
		6:
			DialogueHelper.play_dialogue("pig_1_lie", "Pig")
			source.hide()
		_:
			DialogueHelper.play_dialogue_sequence(["pig_1_1", "pig_1_2"], ["Pig", "Pig"])
			source.hide()
	
func _on_pig_2_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		5:
			DialogueHelper.play_dialogue_sequence(["pig_2_truth", "pig_watching"], ["Weird pig", "Pig Brother"])
			source.hide()
		6:
			DialogueHelper.play_dialogue("pig_2_lie", "Pig")
			source.hide()
		_:
			DialogueHelper.play_dialogue_sequence(["pig_2_1", "pig_2_2"], ["Weird pig", "Weird pig"])
			source.hide()

func _on_pig_3_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		5:
			DialogueHelper.play_dialogue("pig_3_truth", "Sleeping pig")
			source.hide()
		_:
			DialogueHelper.play_dialogue_sequence(["pig_3_1", "pig_3_2"], ["Sleeping pig", "Sleeping pig"])
			source.hide()


func _on_pig_4_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		5:
			DialogueHelper.play_dialogue_sequence(["pig_4_truth", "pig_watching"], ["Pig", "Pig Brother"])
			source.hide()
		6:
			DialogueHelper.play_dialogue("pig_4_lie", "Pig")
			source.hide()
		_:
			DialogueHelper.play_dialogue_sequence(["pig_4_1", "pig_4_2"], ["Pig", "Pig"])
			source.hide()


func _on_pig_5_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		2:
			DialogueHelper.play_dialogue_sequence(["pig_5_1", "pig_5_2"], ["Blueberry pig", "Blueberry pig"])
			source.hide()
		3:
			DialogueHelper.play_dialogue("pig_5_3", "Blueberry pig")
			$TileMap.set_cell(3, Vector2(129, -88))
			source.hide()
		5:
			DialogueHelper.play_dialogue_sequence(["pig_5_truth", "pig_watching"], ["Pignistry pig", "Pig Brother"])
			source.hide()
		6:
			DialogueHelper.play_dialogue("pig_5_lie", "Pig")
			source.hide()


func _on_pig_6_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		5:
			DialogueHelper.play_dialogue_sequence(["pig_6_truth", "pig_watching"], ["Pig", "Pig Brother"])
			source.hide()
		6:
			DialogueHelper.play_dialogue("pig_6_lie", "Pig")
			source.hide()
		_:
			DialogueHelper.play_dialogue_sequence(["pig_6_1", "pig_6_2"], ["Pig", "Pig"])
			source.hide()


func _on_pig_7_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		6:
			DialogueHelper.play_dialogue("pig_7_lie", "Pig")
			source.hide()
		_:
			DialogueHelper.play_dialogue_sequence(["pig_7_1", "pig_7_2"], ["Guard pig", "Guard pig"])
			source.hide()


func _on_pig_8_trigger_action_done(source: ActionTrigger) -> void:
	print(StateHelper.gets("lucas_temple"))
	match StateHelper.gets("lucas_temple"):
		2:
			DialogueHelper.play_dialogue_sequence(["pig_8_1", "pig_8_2", "pig_8_3"], ["Pig Brother", "Pig Brother", "Pig Brother"])
			source.hide()
			StateHelper.sets("lucas_temple", 3)
			$TemplePig/Pigs/Pig5/Pig5Trigger.show()
		3:
			DialogueHelper.play_dialogue("pig_8_3", "Pig Brother")
		4:
			var fate_box_texture = DialogueHelper.fate_box.center_texture 
			fate_box_texture.scale = Vector2(20, 20)
			fate_box_texture.position = Vector2(464, 184)
			DialogueHelper.set_up_fate("Tell truth", "Tell lies", preload("res://scenes/characters/level1/pig_big_texture.tres"),
			pigs_kill_big_pig, pigs_return_to_people)
			await DialogueHelper.fate_box.fate_chosen
			DialogueHelper.player.restrict_movement()
			QuestHelper.remove_quest("Capybara Jones")
			source.hide()
		5:  
			DialogueHelper.play_dialogue("pig_master_watching", "Pig Brother")
		6:
			DialogueHelper.play_dialogue("pig_8_lie_2", "Pig")
			source.hide()


func _on_pig_big_trigger_action_done(source: ActionTrigger) -> void:
	source.queue_free()
	DialogueHelper.play_dialogue_sequence(["pig_big_1", "pig_big_2"], ["Big pig", "Big pig"])
	StateHelper.sets("lucas_temple", 4)
	$TemplePig/Pigs/Pig8/Pig8Trigger.show()
	await DialogueHelper.dialogue_box.dialogue_finished
	DialogueHelper.start_cutscene_set_up()
	var tilemap: TileMap = $TileMap
	var big_pig = $TemplePig/Pigs/PigBig
	var tween = create_tween()
	tween.tween_callback(func(): big_pig.animation_player.play("shake"))
	tween.tween_property(big_pig, ^"position", big_pig.position + Vector2(16, 0), 1)
	tween.tween_callback(func(): big_pig.animation_player.stop())
	tween.tween_callback(
		func():
			tilemap.set_cell(3, Vector2(196, -146))
			tilemap.set_cell(3, Vector2(196, -145))
	)
	tween.tween_property(big_pig, ^"scale", Vector2(3.5, 3.5), 2)
	tween.tween_callback(func(): big_pig.animation_player.play("shake"))
	tween.tween_property(big_pig, ^"position", big_pig.position + Vector2(32, 0), 1)
	tween.tween_callback(func(): big_pig.animation_player.stop())
	tween.tween_callback(
		func():
			tilemap.set_cell(3, Vector2(198, -146))
			tilemap.set_cell(3, Vector2(198, -145))
	)
	tween.tween_property(big_pig, ^"scale", Vector2(4, 4), 3)
	await tween.finished
	DialogueHelper.stop_cutscene_set_up()

func obtain_red_key() -> void:
	DialogueHelper.set_up_acquisition("Red key", preload("res://assets/sprites/level1/keys/red_key.png"))
	StateHelper.sets("red_key", 1)

func pigs_kill_big_pig() -> void:
	StateHelper.sets("lucas_temple", 5)
	var tilemap: TileMap = $TileMap
	var meat_coords = [Vector2(192, -146), Vector2(194, -146), Vector2(192, -144), Vector2(194, -144)]
	for coord in meat_coords:
		tilemap.set_cell(3, coord, 3, Vector2(1, 0))
	$TemplePig/Pigs/PigBig.queue_free()
	$TemplePig/Pigs/Pig1/Pig1Trigger.show()
	$TemplePig/Pigs/Pig1.position = $TemplePig/Pig1NewPos.position
	$TemplePig/Pigs/Pig2/Pig2Trigger.show()
	$TemplePig/Pigs/Pig3/Pig3Trigger.show()
	$TemplePig/Pigs/Pig4/Pig4Trigger.show()
	$TemplePig/Pigs/Pig5/Pig5Trigger.show()
	$TemplePig/Pigs/Pig6/Pig6Trigger.show()
	
	DialogueHelper.play_dialogue("pig_8_truth", "Pig Brother")
	await DialogueHelper.dialogue_box.dialogue_finished
	obtain_red_key()
	await DialogueHelper.acqusition_box.item_taken
	DialogueHelper.play_dialogue("pig_8_3", "Pig Brother")
	

func pigs_return_to_people() -> void:
	StateHelper.sets("lucas_temple", 6)
	DialogueHelper.play_dialogue_sequence(["pig_8_lie", "pig_8_lie_key"], ["No longer Pig Brother", "No longer Pig Brother"])
	await DialogueHelper.dialogue_box.dialogue_finished
	obtain_red_key()
	await DialogueHelper.acqusition_box.item_taken
	var pig1: MovableCharacterBase = $TemplePig/Pigs/Pig1
	var pig1_trigger = $TemplePig/Pigs/Pig1/Pig1Trigger
	var pig2: MovableCharacterBase = $TemplePig/Pigs/Pig2
	var pig2_trigger = $TemplePig/Pigs/Pig2/Pig2Trigger
	var pig4: MovableCharacterBase = $TemplePig/Pigs/Pig4
	var pig4_trigger = $TemplePig/Pigs/Pig4/Pig4Trigger
	var pig5: MovableCharacterBase = $TemplePig/Pigs/Pig5
	var pig5_trigger = $TemplePig/Pigs/Pig5/Pig5Trigger
	var pig6: MovableCharacterBase = $TemplePig/Pigs/Pig6
	var pig6_trigger = $TemplePig/Pigs/Pig6/Pig6Trigger
	var pig7: MovableCharacterBase = $TemplePig/Pigs/Pig7
	var pig7_trigger = $TemplePig/Pigs/Pig7/Pig7Trigger
	var pig8: MovableCharacterBase = $TemplePig/Pigs/Pig8
	var pig8_trigger = $TemplePig/Pigs/Pig8/Pig8Trigger
	var pigs: Array[MovableCharacterBase] = [pig1, pig2, pig4, pig5, pig6, pig7, pig8]
	var triggers: Array[ActionTrigger] = [pig1_trigger, pig2_trigger, pig4_trigger, pig5_trigger, pig6_trigger, pig7_trigger, pig8_trigger]
	
	for t in triggers:
		t.make_inactive()
	for p in pigs:
		p.start_moving()
	
	await pig8.path_finished
	for t in triggers:
		t.make_active()


func _on_scroll_1_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_scroll_1")


func _on_note_1_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_note_1")


func _on_note_2_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_note_2")


func _on_book_1_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_book_1_1", "pig_prop_book_1_2"])


func _on_book_2_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_book_2_1", "pig_prop_book_2_2"])


func _on_violet_crystal_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_crystal_violet_1", "pig_prop_crystal_violet_2"])


func _on_coins_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_coins")


func _on_buggy_bed_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_bed_1", "pig_prop_bed_2"])


func _on_crypt_sign_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_sign_crypt")


func _on_gin_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_crypt_gin")


func _on_heaven_sign_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_crypt_sign_1", "pig_crypt_sign_2"])


func _on_dragon_fight_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_crypt_dragons")


func _on_monkey_king_trigger_action_done(_source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_crypt_inscribing")


func _on_undone_alcove_trigger_player_entered(source: Area2D) -> void:
	if StateHelper.gets("evil_snake") < 2:
		DialogueHelper.play_dialogue("story_undone_1")
		DialogueHelper.player.hivemind_velocity = Vector2(-1, -1).normalized()
		source.body_exited.connect(func(_b): DialogueHelper.player.hivemind_velocity = Vector2.ZERO, CONNECT_ONE_SHOT)
	else:
		source.queue_free()


func _on_thomas_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("green_key") == 1:
		DialogueHelper.play_dialogue("follower_thomas_end")
		source.hide()
		return
	
	DialogueHelper.play_dialogue_sequence(
		["follower_thomas_1", "follower_thomas_2", "follower_thomas_3"],
		["Thomas", "Thomas", "Thomas"])
	await DialogueHelper.dialogue_box.dialogue_finished
	var fate_box_image = DialogueHelper.fate_box.center_texture
	fate_box_image.scale = Vector2(5, 5)
	fate_box_image.position = Vector2(576, 220)
	DialogueHelper.set_up_fate("Pineapple", "Pizza", preload("res://assets/sprites/level1/pizza_pineapple.png"),
	func():StateHelper.sets("pineapple_or_pizza", 1),
	func(): StateHelper.sets("pineapple_or_pizza", -1))
	await DialogueHelper.fate_box.fate_chosen
	DialogueHelper.play_dialogue("follower_thomas_fated", "Thomas")
	source.make_inactive()
	on_talked_with_follower()


func _on_sergio_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("green_key") == 1:
		DialogueHelper.play_dialogue("follower_sergio_end")
		source.hide()
		return
	
	DialogueHelper.play_dialogue_sequence(
		["follower_sergio_1", "follower_sergio_2", "follower_sergio_3", "follower_sergio_4", "follower_sergio_5"],
		["Sergio", "Sergio", "Sergio", "Sergio", "Sergio"]
	)
	source.make_inactive()
	on_talked_with_follower()


func _on_isolde_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("green_key") == 1:
		DialogueHelper.play_dialogue("follower_isolde_end")
		source.hide()
		return
	
	DialogueHelper.play_dialogue_sequence(
		["follower_isolde_1", "follower_isolde_2", "follower_isolde_3"],
		["Isolde", "Isolde", "Isolde"]
	)
	source.make_inactive()
	on_talked_with_follower()


func _on_olaf_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("green_key") == 1:
		DialogueHelper.play_dialogue("follower_olaf_end")
		source.hide()
		return
	
	DialogueHelper.start_cutscene_set_up()
	var olaf: MovableCharacterBase = $FollowerCamp/FollowerOlaf
	var olaf_trigger: ActionTrigger = olaf.get_node(^"OlafTrigger")
	var player_camera = DialogueHelper.player.get_node(^"Camera2D")
	source.make_inactive()
	var message_bubble: AnimatedSprite2D = olaf.message_bubble
	
	await create_tween().tween_property(player_camera, ^"offset", Vector2(0, 32), 0.5).finished
	
	message_bubble.show()
	DialogueHelper.play_dialogue("follower_olaf_1", "Olaf")
	await DialogueHelper.dialogue_box.dialogue_finished
	message_bubble.hide()
	var olaf_start_pos = olaf.position
	var olaf_start_collision = olaf.collision_mask
	var player_start_collision = DialogueHelper.player.collision_mask
	olaf.collision_mask = 1
	DialogueHelper.player.collision_mask = 0
	var tween = create_tween()
	tween.tween_method(
		func(v):
			olaf.velocity = v
			olaf.move_and_collide(v * d),
		Vector2.ZERO,
		Vector2(0, 200),
		0.5
	)
	await tween.finished
	await perform_jump(olaf).finished
	
	message_bubble.show()
	DialogueHelper.play_dialogue("follower_olaf_2", "Olaf")
	await DialogueHelper.dialogue_box.dialogue_finished
	message_bubble.hide()
	await perform_jump(olaf).finished
	olaf.rotation = PI
	tween = create_tween()
	tween.tween_property(olaf, ^"position", Vector2(85.62, -33), 0.5)
	tween.tween_callback(func(): olaf.rotation = PI / 2)
	tween.tween_property(olaf, ^"position", Vector2(-42.38, -33), 0.5)
	await tween.finished
	
	message_bubble.show()
	DialogueHelper.play_dialogue("follower_olaf_3", "Olaf")
	await DialogueHelper.dialogue_box.dialogue_finished
	message_bubble.hide()
	create_tween().tween_property(olaf, ^"rotation", TAU, 2)
	await create_tween().tween_property(olaf, ^"position", Vector2(-42.38, 127), 2).finished
	
	message_bubble.show()
	DialogueHelper.play_dialogue("follower_olaf_4", "Olaf")
	olaf.get_node("Glasses").show()
	await DialogueHelper.dialogue_box.dialogue_finished
	message_bubble.hide()
	await create_tween().tween_property(olaf, ^"position", Vector2(5.62, 47), 1).finished
	
	message_bubble.show()
	DialogueHelper.play_dialogue("follower_olaf_5", "Olaf")
	await DialogueHelper.dialogue_box.dialogue_finished
	message_bubble.hide()
	olaf.get_node("Glasses").queue_free()
	var sprite = olaf.get_node("Sprite2D")
	var pablo = olaf.get_node("Pablo")
	create_tween().tween_property(sprite, ^"modulate", Color.TRANSPARENT, 2)
	await create_tween().tween_property(pablo, ^"modulate", Color.WHITE, 2).finished
	
	DialogueHelper.play_dialogue("follower_olaf_6", "Pablo?")
	await DialogueHelper.dialogue_box.dialogue_finished
	await create_tween().tween_property(pablo, ^"modulate", Color.TRANSPARENT, 2).finished
	pablo.queue_free()
	olaf.position = olaf_start_pos
	await create_tween().tween_property(sprite, ^"modulate", Color.WHITE, 2).finished
	
	olaf.collision_mask = olaf_start_collision
	DialogueHelper.player.collision_mask = player_start_collision
	DialogueHelper.stop_cutscene_set_up()
	on_talked_with_follower()

func perform_jump(olaf: MovableCharacterBase) -> Tween:
	var tween = create_tween()
	var jump_vec = Vector2(0, -300)
	tween.tween_method(
		func(v):
			olaf.velocity = v
			olaf.move_and_collide(v * d),
		jump_vec,
		Vector2(0, 200),
		1
	)
	tween.tween_method(
		func(v):
			olaf.velocity = v
			olaf.move_and_collide(v * d),
		Vector2(0, 200),
		Vector2(0, 200),
		0.5
	)
	return tween
	
func on_talked_with_follower() -> void:
	StateHelper.sets("followers_acquainted", StateHelper.gets("followers_acquainted") + 1)
	if StateHelper.gets("followers_acquainted") == 5:
		$FollowerCamp/FollowerAsedine/AsedineTrigger.show()

func _on_asedine_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("green_key") == 1:
		DialogueHelper.play_dialogue("follower_asedine_end")
		source.hide()
		return
	
	if StateHelper.gets("asedine_talked") == 0:
		DialogueHelper.play_dialogue("follower_asedine_1", "Asedine")
		StateHelper.sets("asedine_talked", 1)
		await DialogueHelper.dialogue_box.dialogue_finished
	
	if StateHelper.gets("sticks_collected") == 5:
		followers_cutscene()
		return
	
	match StateHelper.gets("followers_acquainted"):
		5:
			DialogueHelper.play_dialogue("follower_asedine_3", "Asedine")
			source.hide()
			await DialogueHelper.dialogue_box.dialogue_finished
			QuestHelper.add_quest("Stranger Sticks")
			$FollowerCamp/FollowerBondurnar.position += Vector2(0, 16)
			
		_:
			DialogueHelper.play_dialogue("follower_asedine_2", "Asedine")
			source.hide()


func _on_bondurnar_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("green_key") == 1:
		DialogueHelper.play_dialogue("follower_bondurnar_end")
		source.hide()
		return
	
	source.make_inactive()
	var bondurnar: MovableCharacterBase = $FollowerCamp/FollowerBondurnar
	var message_bubble = bondurnar.message_bubble
	message_bubble.show()
	DialogueHelper.start_cutscene_set_up()
	DialogueHelper.play_dialogue("follower_bondurnar_1", "Bondurnar")
	await DialogueHelper.dialogue_box.dialogue_finished
	var player = DialogueHelper.player
	var tween = create_tween()
	var top_position = player.position + Vector2(0, -16)
	var bottom_position = player.position
	tween.tween_property(player, ^"position", top_position, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player, ^"position", bottom_position, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	DialogueHelper.play_dialogue("follower_bondurnar_2", "Bondurnar")
	await DialogueHelper.dialogue_box.dialogue_finished
	var particles: CPUParticles2D = bondurnar.get_node(^"CPUParticles2D")
	particles.emitting = true
	await create_tween().tween_interval(2).finished
	particles.emitting = false
	DialogueHelper.play_dialogue_sequence(
		["follower_bondurnar_3", "follower_bondurnar_4", "follower_bondurnar_5", "follower_bondurnar_6"],
		["Bondurnar", "Bondurnar", "Bondurnar", "Bondurnar"])
	await DialogueHelper.dialogue_box.dialogue_finished
	await create_tween().tween_property(bondurnar.get_node(^"Sprite2D"), ^"modulate", Color.RED, 1)
	DialogueHelper.play_dialogue("follower_bondurnar_7", "Bondurnar")
	await DialogueHelper.dialogue_box.dialogue_finished
	message_bubble.hide()
	DialogueHelper.stop_cutscene_set_up()
	on_talked_with_follower()
	particles.queue_free()

func on_stick_pocketed() -> void:
	StateHelper.sets("sticks_collected", StateHelper.gets("sticks_collected") + 1)
	QuestHelper.poll_quests()

func _on_stick_1_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("follower_stick_1")
	await DialogueHelper.dialogue_box.dialogue_finished
	$StickyForest/Stick1.queue_free()
	on_stick_pocketed()


func _on_stick_2_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("follower_stick_2")
	await DialogueHelper.dialogue_box.dialogue_finished
	$StickyForest/Stick2.queue_free()
	on_stick_pocketed()


func _on_stick_3_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("follower_stick_3")
	await DialogueHelper.dialogue_box.dialogue_finished
	$StickyForest/Stick3.queue_free()
	on_stick_pocketed()


func _on_stick_4_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("follower_stick_4")
	await DialogueHelper.dialogue_box.dialogue_finished
	$StickyForest/Stick4.queue_free()
	on_stick_pocketed()


func _on_stick_5_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("follower_stick_5")
	await DialogueHelper.dialogue_box.dialogue_finished
	$StickyForest/Stick5.queue_free()
	on_stick_pocketed()


func _on_teleport_1_trigger_player_entered(source: Area2D) -> void:
	var tp_zone = Vector2(4008, 504)
	DialogueHelper.player.global_position = tp_zone


func _on_teleport_2_trigger_player_entered(source: Area2D) -> void:
	var tp_zone = Vector2(4112, 1136)
	DialogueHelper.player.global_position = tp_zone


func _on_nothingness_trigger_action_done(source: ActionTrigger) -> void:
	source.queue_free()
	DialogueHelper.start_cutscene_set_up()
	DialogueHelper.play_dialogue("follower_wrong_passage_1")
	await DialogueHelper.dialogue_box.dialogue_finished
	var mesmerizing_void: Sprite2D = $StickyForest/Void
	await create_tween().tween_property(mesmerizing_void, ^"modulate", Color.WHITE, 2)
	DialogueHelper.play_dialogue("follower_wrong_passage_2")
	await DialogueHelper.dialogue_box.dialogue_finished
	mesmerizing_void.texture = preload("res://assets/sprites/level1/mesmerizing_void2.png")
	DialogueHelper.play_dialogue("follower_wrong_passage_3")
	await DialogueHelper.dialogue_box.dialogue_finished
	DialogueHelper.stop_cutscene_set_up()


func _on_help_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	DialogueHelper.start_cutscene_set_up()
	DialogueHelper.play_dialogue("follower_help_1")
	await DialogueHelper.dialogue_box.dialogue_finished
	await create_tween().tween_interval(3).finished
	DialogueHelper.play_dialogue("follower_help_2")
	await DialogueHelper.dialogue_box.dialogue_finished
	DialogueHelper.stop_cutscene_set_up()

func followers_cutscene() -> void:
	QuestHelper.remove_quest("Stranger Sticks")
	DialogueHelper.play_dialogue("follower_asedine_4", "Asedine")
	await DialogueHelper.dialogue_box.dialogue_finished
	DialogueHelper.start_cutscene_set_up()
	
	var tilemap: TileMap = $TileMap
	tilemap.set_cell(0, Vector2(128, 36), 0, Vector2(14, 8))
	await create_tween().tween_property(self, ^"modulate", Color.BLACK, 2).finished
	
	var capybara_marker = $FollowerCamp/Ceremony/CapybaraMarker
	var asedine_marker = $FollowerCamp/Ceremony/AsedineMarker
	var asedine = $FollowerCamp/FollowerAsedine
	asedine.global_position = asedine_marker.global_position
	DialogueHelper.player.global_position = capybara_marker.global_position
	$FollowerCamp/Ceremony/FireParticles.emitting = true
	var followers: Array[MovableCharacterBase]
	followers = [$FollowerCamp/FollowerThomas, $FollowerCamp/FollowerSergio, $FollowerCamp/FollowerIsolde,
	$FollowerCamp/FollowerOlaf]
	var triggers: Array[ActionTrigger]
	triggers = [$FollowerCamp/FollowerThomas/ThomasTrigger, $FollowerCamp/FollowerSergio/SergioTrigger,
	$FollowerCamp/FollowerIsolde/IsoldeTrigger, $FollowerCamp/FollowerOlaf/OlafTrigger, $FollowerCamp/FollowerAsedine/AsedineTrigger]
	for t in triggers:
		t.make_inactive()
	
	await create_tween().tween_interval(1).finished
	await create_tween().tween_property(self, ^"modulate", Color(0.508, 0.508, 0.508), 2).finished
	asedine.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_1_asedine", "Asedine")
	await DialogueHelper.dialogue_box.dialogue_finished
	asedine.hide_message_bubble()
	for f in followers:
		f.start_moving()
	await followers[1].path_finished
	asedine.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_2_asedine", "Asedine")
	await DialogueHelper.dialogue_box.dialogue_finished
	
	DialogueHelper.play_dialogue("ceremony_3_asedine", "Asedine")
	create_tween().tween_property(asedine.get_node(^"Magick"), ^"modulate", Color.WHITE, 3)
	await DialogueHelper.dialogue_box.dialogue_finished
	asedine.hide_message_bubble()
	
	var thomas = followers[0]
	thomas.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_4_thomas", "Thomas")
	create_tween().tween_property(thomas.get_node(^"Magick"), ^"modulate", Color.WHITE, 3)
	await DialogueHelper.dialogue_box.dialogue_finished
	thomas.hide_message_bubble()
	
	var sergio = followers[1]
	sergio.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_5_sergio", "Sergio")
	create_tween().tween_property(sergio.get_node(^"Magick"), ^"modulate", Color.WHITE, 3)
	await DialogueHelper.dialogue_box.dialogue_finished
	sergio.hide_message_bubble()
	
	var isolde = followers[2]
	isolde.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_6_isolde", "Isolde")
	create_tween().tween_property(isolde.get_node(^"Magick"), ^"modulate", Color.WHITE, 3)
	await DialogueHelper.dialogue_box.dialogue_finished
	isolde.hide_message_bubble()
	
	var olaf = followers[3]
	olaf.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_7_olaf", "Olaf")
	create_tween().tween_property(olaf.get_node(^"Magick"), ^"modulate", Color.WHITE, 3)
	await DialogueHelper.dialogue_box.dialogue_finished
	olaf.hide_message_bubble()
	
	var pathsCounterClockwise: Array[PathFollow2D]
	pathsCounterClockwise = [
		$FollowerCamp/Ceremony/ThomasCeremonyPath/PathFollow2D,
		$FollowerCamp/Ceremony/SergioCeremonyPath/PathFollow2D,
		$FollowerCamp/Ceremony/IsoldeCeremonyPath/PathFollow2D,
		$FollowerCamp/Ceremony/OlafCeremonyPath/PathFollow2D,
		$FollowerCamp/Ceremony/AsedineCeremonyPath/PathFollow2D
	]
	thomas.set_path(pathsCounterClockwise[0])
	sergio.set_path(pathsCounterClockwise[1])
	isolde.set_path(pathsCounterClockwise[2])
	olaf.set_path(pathsCounterClockwise[3])
	asedine.set_path(pathsCounterClockwise[4])
	await asedine.path_finished
	
	var pathsClockwise: Array[PathFollow2D]
	pathsClockwise = [
		$FollowerCamp/Ceremony/ThomasCeremonyPath2/PathFollow2D,
		$FollowerCamp/Ceremony/SergioCeremonyPath2/PathFollow2D,
		$FollowerCamp/Ceremony/IsoldeCeremonyPath2/PathFollow2D,
		$FollowerCamp/Ceremony/OlafCeremonyPath2/PathFollow2D,
		$FollowerCamp/Ceremony/AsedineCeremonyPath2/PathFollow2D
	]
	thomas.set_path(pathsClockwise[0])
	sergio.set_path(pathsClockwise[1])
	isolde.set_path(pathsClockwise[2])
	olaf.set_path(pathsClockwise[3])
	asedine.set_path(pathsClockwise[4])
	await asedine.path_finished
	
	var bondurnar = $FollowerCamp/FollowerBondurnar
	$FollowerCamp/FollowerBondurnar/BondurnarTrigger.make_inactive()
	bondurnar.set_path($FollowerCamp/Ceremony/BondurnarCeremonyPath/PathFollow2D)
	await bondurnar.path_finished
	bondurnar.show_message_bubble()
	DialogueHelper.play_dialogue("ceremony_8_bondurnar", "Bondurnar")
	await DialogueHelper.dialogue_box.dialogue_finished
	bondurnar.hide_message_bubble()
	
	StateHelper.sets("green_key", 1)
	DialogueHelper.acqusition_box.center_texture.position = Vector2(528, 208)
	DialogueHelper.set_up_acquisition("Green key", preload("res://assets/sprites/level1/keys/green_key.png"))
	for t in triggers:
		t.make_active()
	$FollowerCamp/FollowerBondurnar/BondurnarTrigger.make_active()
	await DialogueHelper.acqusition_box.item_taken
	DialogueHelper.stop_cutscene_set_up()


func _on_big_door_trigger_action_done(source: ActionTrigger) -> void:
	var key_r: int = StateHelper.gets("red_key")
	var key_g: int = StateHelper.gets("green_key")

	if key_r == 0 and key_g == 0:
		DialogueHelper.play_dialogue("rg_door_no_rg")
		return
	elif key_r == 0:
		DialogueHelper.play_dialogue("rg_door_no_r")
		return
	elif key_g == 0:
		DialogueHelper.play_dialogue("rg_door_no_g")
		return
	else:
		DialogueHelper.play_dialogue("rg_door_open")
		source.make_inactive()
		$Finalle/BigDoor.collision_layer = 0
		$Finalle/BigDoor/Sprite2D.texture = preload("res://assets/sprites/level1/rg_door2.png")


func _on_brother_pig_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	if StateHelper.gets("lucas_temple") != 5:
		$Finalle/BrotherPig.queue_free()
		return
	
	$Finalle/BrotherPig.show()
	DialogueHelper.play_dialogue("pig_watching", "???")


func _on_ceo_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("ceo_met") == 0:
		DialogueHelper.play_dialogue_sequence(["ceo_1", "ceo_2", "ceo_3", "ceo_4", "ceo_5"], ["CEO", "CEO", "CEO", "CEO", "CEO"])
		StateHelper.sets("ceo_met", 1)
		await DialogueHelper.dialogue_box.dialogue_finished
		source.hide()
	else:
		DialogueHelper.play_dialogue("ceo_5", "CEO")


func _on_sleepy_1_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	DialogueHelper.play_dialogue("finalle_sleepy_1")
	create_tween().tween_property(self, ^"modulate", Color(0.4, 0.4, 0.4), 1)


func _on_sleepy_2_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	DialogueHelper.play_dialogue("finalle_sleepy_2")
	create_tween().tween_property(self, ^"modulate", Color(0.2, 0.2, 0.2), 1)
	DialogueHelper.player.speed /= 2


func _on_end_trigger_player_entered(source: Area2D) -> void:
	DialogueHelper.player.restrict_movement()
	await create_tween().tween_interval(0.5).finished
	DialogueHelper.player.idling = false
	DialogueHelper.player.animated_sprite.play("sleep")
	await create_tween().tween_interval(2.5).finished
	await create_tween().tween_property(self, ^"modulate", Color.BLACK, 2)
	# TODO credits?
