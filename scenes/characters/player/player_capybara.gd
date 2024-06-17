extends PlayerBase
@export var animated_sprite: AnimatedSprite2D

func _physics_process(delta: float) -> void:
	super(delta)
	if velocity.x > 0:
		animated_sprite.flip_h = true
		animated_sprite.play("walk")
	elif velocity.x < 0:
		animated_sprite.flip_h = false
		animated_sprite.play("walk")
	elif velocity.y > 0:
		animated_sprite.play("down")
	elif velocity.y < 0:
		animated_sprite.play("up")
	else:
		animated_sprite.play("idle")
