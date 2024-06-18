extends CharacterBody2D
class_name MovableCharacterBase

signal path_finished

@export var speed: int = 100
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var message_bubble: AnimatedSprite2D = $AnimatedSprite2D
@export var path: PathFollow2D
@export var is_moving: bool = true

func _physics_process(delta: float) -> void:
	if path and is_moving:
		path.progress += speed * delta
		global_position = path.global_position
		if (path.progress_ratio == 1):
			stop_moving()
			path_finished.emit()

func set_path(path_to_set: PathFollow2D, _start_moving: bool = true):
	path = path_to_set
	if is_moving:
		start_moving()

func start_moving() -> void:
	is_moving = true;
	animation_player.play("shake")

func stop_moving() -> void:
	is_moving = false
	animation_player.stop()

func show_message_bubble() -> void:
	message_bubble.show()
	message_bubble.play("default")

func hide_message_bubble() -> void:
	message_bubble.stop()
	message_bubble.hide()
