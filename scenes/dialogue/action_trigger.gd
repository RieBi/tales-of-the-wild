extends Area2D

signal action_done(source: Area2D)

@export var sprite: AnimatedSprite2D
@export var visible_only_in_zone: bool = false
var player_in_area: bool = false

func _ready() -> void:
	if visible_only_in_zone:
		sprite.hide()

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("action") and not DialogueHelper.is_dialogue_playing():
		action_done.emit(self)

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	if visible_only_in_zone:
		sprite.show()


func _on_body_exited(body: Node2D) -> void:
	if visible_only_in_zone:
		sprite.hide()
	player_in_area = false
