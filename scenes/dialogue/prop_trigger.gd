extends Area2D
class_name PropTrigger

@onready var sprite: Sprite2D = $Sprite2D
@export var dialogues: Array[String]
@export var visible_only_in_zone: bool = true
@export var is_inactive: bool = false
var player_in_area: bool = false

func _ready() -> void:
	if visible_only_in_zone:
		sprite.hide()
	if is_inactive:
		make_inactive()

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("action")\
	and not DialogueHelper.is_dialogue_playing() and DialogueHelper.action_unabliness_timer.is_stopped():
		DialogueHelper.play_dialogue_sequence(dialogues)

func make_inactive() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()

func make_active() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	if not visible_only_in_zone:
		show()

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	if visible_only_in_zone:
		sprite.show()

func _on_body_exited(body: Node2D) -> void:
	if visible_only_in_zone:
		sprite.hide()
	player_in_area = false

