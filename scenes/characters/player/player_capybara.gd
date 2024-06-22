extends PlayerBase
@export var animated_sprite: AnimatedSprite2D

var idling: bool = true

func _physics_process(delta: float) -> void:
	super(delta)
	print(velocity)
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
	elif idling:
		animated_sprite.play("idle")
