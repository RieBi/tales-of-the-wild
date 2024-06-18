extends CharacterBody2D
class_name MovableCharacterBase

@export var speed: int = 100
var path: PathFollow2D
var is_moving: bool = true

func _physics_process(delta: float) -> void:
	if path and is_moving:
		path.progress += speed * delta
		global_position = path.global_position
		if (path.progress_ratio == 1):
			is_moving = false

func set_path(path_to_set: PathFollow2D, start_moving: bool = true):
	path = path_to_set
	is_moving = start_moving
