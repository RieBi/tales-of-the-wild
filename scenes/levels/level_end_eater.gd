extends Node2D

func _ready() -> void:
	hide()

func _on_containment_trigger_action_done(source: ActionTrigger) -> void:
	DialogueHelper.start_cutscene_set_up()
	DialogueHelper.play_dialogue_sequence(["eater_liber_1", "eater_liber_2"])
	await DialogueHelper.dialogue_box.dialogue_finished
	DialogueHelper.player.idling = false
	DialogueHelper.player.animated_sprite.play("sleep")
	StateHelper.sets("finished", 1)
	await create_tween().tween_property(self, ^"modulate", Color.BLACK, 5).finished
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")


func _on_enter_trigger_player_entered(source: Area2D) -> void:
	DialogueHelper.play_dialogue("eater_intro_1")
	await DialogueHelper.dialogue_box.dialogue_finished
	show()
	DialogueHelper.play_dialogue("eater_intro_2")
