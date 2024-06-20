extends Node2D


func _on_awaken_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	hide()
	DialogueHelper.play_dialogue("story_1")
	DialogueHelper.add_finish_func(func():
		show()
		DialogueHelper.play_dialogue("story_2"))


func _on_crystal_trigger_action_done(source: Area2D) -> void:
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


func _on_apple_tree_trigger_action_done(source: Area2D) -> void:
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



func _on_snake_left_trigger_action_done(source: Area2D) -> void:
	DialogueHelper.play_dialogue("evil_snake_left")


func _on_inscribing_trigger_action_done(source: Area2D) -> void:
	DialogueHelper.play_dialogue_sequence(["evil_snake_prophecy_1", "evil_snake_prophecy_1_think"])


func _on_cave_trigger_action_done(source: Area2D) -> void:
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


func _on_angered_mom_trigger_action_done(source: ActionTrigger) -> void:
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
			DialogueHelper.play_dialogue_sequence(["pig_1_truth", "pig_watching"], ["Pig", "Master"])
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
			DialogueHelper.play_dialogue_sequence(["pig_2_truth", "pig_watching"], ["Weird pig", "Master"])
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
			DialogueHelper.play_dialogue_sequence(["pig_4_truth", "pig_watching"], ["Pig", "Master"])
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
			DialogueHelper.play_dialogue_sequence(["pig_5_truth", "pig_watching"], ["Pignistry pig", "Master"])
			source.hide()
		6:
			DialogueHelper.play_dialogue("pig_5_lie", "Pig")
			source.hide()


func _on_pig_6_trigger_action_done(source: ActionTrigger) -> void:
	match StateHelper.gets("lucas_temple"):
		5:
			DialogueHelper.play_dialogue_sequence(["pig_6_truth", "pig_watching"], ["Pig", "Master"])
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
			DialogueHelper.play_dialogue_sequence(["pig_8_1", "pig_8_2", "pig_8_3"], ["Master", "Master", "Master"])
			source.hide()
			StateHelper.sets("lucas_temple", 3)
			$TemplePig/Pigs/Pig5/Pig5Trigger.show()
		3:
			DialogueHelper.play_dialogue("pig_8_3", "Master")
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
			DialogueHelper.play_dialogue("pig_master_watching", "Master")
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
	
	DialogueHelper.play_dialogue("pig_8_truth", "Master")
	await DialogueHelper.dialogue_box.dialogue_finished
	DialogueHelper.set_up_acquisition("Red key", preload("res://assets/sprites/level1/keys/red_key.png"))
	await DialogueHelper.acqusition_box.item_taken
	StateHelper.sets("red_key", 1)
	DialogueHelper.play_dialogue("pig_8_3", "Master")
	

func pigs_return_to_people() -> void:
	StateHelper.sets("lucas_temple", 6)
	DialogueHelper.play_dialogue("pig_8_lie", "No longer master")
	await DialogueHelper.dialogue_box.dialogue_finished
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


func _on_scroll_1_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_scroll_1")


func _on_note_1_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_note_1")


func _on_note_2_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_note_2")


func _on_book_1_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_book_1_1", "pig_prop_book_1_2"])


func _on_book_2_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_book_2_1", "pig_prop_book_2_2"])


func _on_violet_crystal_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_crystal_violet_1", "pig_prop_crystal_violet_2"])


func _on_coins_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_coins")


func _on_buggy_bed_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_prop_bed_1", "pig_prop_bed_2"])


func _on_crypt_sign_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_prop_sign_crypt")


func _on_gin_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_crypt_gin")


func _on_heaven_sign_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue_sequence(["pig_crypt_sign_1", "pig_crypt_sign_2"])


func _on_dragon_fight_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_crypt_dragons")


func _on_monkey_king_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.play_dialogue("pig_crypt_inscribing")
