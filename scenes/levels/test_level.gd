extends Node2D

func _ready() -> void:
	pass

func _on_demo_dialogues_body_entered(source: Area2D) -> void:
	match StateHelper.gets("demo_1"):
		0:
			DialogueHelper.play_dialogue("demo_10", "Storyteller")
			DialogueHelper.set_state_upon_finish("demo_1", 1)
		1:
			DialogueHelper.play_dialogue("demo_11")
			DialogueHelper.set_state_upon_finish("demo_1", 2)
			source.queue_free()


func _on_enter_trigger_player_entered(source: Area2D) -> void:
	var body1: MovableCharacterBase = $Body1
	body1.set_path($Path2D/PathFollow2D)
