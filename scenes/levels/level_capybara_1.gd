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
