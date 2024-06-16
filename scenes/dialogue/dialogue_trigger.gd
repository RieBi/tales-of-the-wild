extends Area2D

@export var dialogue_id: String
@export var dialogue_teller_name: String = ""
@export var dialogue_portrait: String = ""
@export var radius: int = 10

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius

func _on_body_entered(_body: Node2D) -> void:
	DialogueHelper.play_dialogue(dialogue_id, dialogue_teller_name, dialogue_portrait)
	queue_free()
