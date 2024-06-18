extends Area2D
class_name ActionTrigger

signal action_done(source: Area2D)

@export var sprite: AnimatedSprite2D
@export var animation_to_play: String = "default"
@export var visible_only_in_zone: bool = false
@export var is_inactive: bool = false
var player_in_area: bool = false

func _ready() -> void:
	if visible_only_in_zone:
		sprite.hide()
	sprite.play(animation_to_play)
	if is_inactive:
		make_inactive()

func make_inactive() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()

func make_active() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	if not visible_only_in_zone:
		show()

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("action")\
	and not DialogueHelper.is_dialogue_playing() and DialogueHelper.action_unabliness_timer.is_stopped():
		action_done.emit(self)

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	if visible_only_in_zone:
		sprite.show()


func _on_body_exited(body: Node2D) -> void:
	if visible_only_in_zone:
		sprite.hide()
	player_in_area = false
