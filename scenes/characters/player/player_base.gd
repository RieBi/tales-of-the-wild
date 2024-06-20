extends CharacterBody2D
class_name PlayerBase

@export var speed: int
var is_movement_restricted := false
var hivemind_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	DialogueHelper.set_player(self)

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var acceleration_time: float = 5.0
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction and hivemind_velocity != Vector2.ZERO:
		velocity = hivemind_velocity * speed
	elif direction and not is_movement_restricted:
		velocity = velocity.move_toward(direction * speed, speed / acceleration_time)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed / acceleration_time)

	move_and_slide()

func restrict_movement() -> void: is_movement_restricted = true
func unrestrict_movement() -> void: is_movement_restricted = false
