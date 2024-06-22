extends CanvasLayer
@onready var melon = $Melon
@onready var anpizza: Sprite2D = $Melon/Anpizza
@onready var vvoid: Sprite2D = $Melon/Void


func _ready() -> void:
	melon.position.y = 750
	if StateHelper.gets("finished") == 0:
		anpizza.hide()
		vvoid.hide()
	if StateHelper.gets("pineapple_or_pizza") == 1:
		anpizza.texture = preload("res://assets/sprites/anpizza/anpizza2.png")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		go_to_main()

	
	var speed = 70
	if Input.is_action_pressed("action"):
		speed *= 3
	
	if melon.position.y > -1250:
		melon.position.y -= speed * delta

func go_to_main() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
