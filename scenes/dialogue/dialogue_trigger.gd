extends Area2D

@export var dialogue_id: String
@export var radius: int = 10

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius

func _on_body_entered(_body: Node2D) -> void:
	DialogueHelper.play_dialogue(dialogue_id)
	queue_free()
