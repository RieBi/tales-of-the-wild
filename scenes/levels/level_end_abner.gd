extends Node2D

func _ready() -> void:
	hide()

func _on_jon_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("jon_met") == 0:
		DialogueHelper.play_dialogue_sequence(["abner_jon_1", "abner_jon_2", "abner_jon_3"], ["Jon", "Jon", "Jon"])
		StateHelper.sets("jon_met", 1)
	else:
		DialogueHelper.play_dialogue("abner_jon_3", "Jon")


func _on_action_trigger_action_done(source: ActionTrigger) -> void:
	if StateHelper.gets("jelly_met") == 0:
		DialogueHelper.play_dialogue_sequence(["abner_jelly_1", "abner_jelly_2", "abner_jelly_3"], ["Jelly", "Jelly", "Jelly"])
		StateHelper.sets("jelly_met", 1)
	else:
		DialogueHelper.play_dialogue("abner_jelly_3", "Jelly")


func _on_enter_trigger_player_entered(source: Area2D) -> void:
	source.queue_free()
	DialogueHelper.play_dialogue("abner_1")
	await DialogueHelper.dialogue_box.dialogue_finished
	show()
	DialogueHelper.play_dialogue("abner_2")
