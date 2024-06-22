extends CanvasLayer
class_name SettingsMenu

static func Settings(parent_node: Node) -> void:
	print("RUN")
	var scene = load("res://scenes/menus/settings_menu.tscn").instantiate()
	parent_node.add_child(scene)
	scene.load_settings()

@onready var flickering_options: OptionButton = $Settings/Options/FlickeringOptions
@onready var fullscreen_button: CheckBox = $Settings/Options/FullscreenButton

func load_settings() -> void:
	var flickering: int = SettingsHelper.gets("epilepsy_mode")
	var fullscreen: int = SettingsHelper.gets("fullscreen_mode")
	
	flickering_options.selected = flickering
	fullscreen_button.button_pressed = fullscreen == 1

func save_settings() -> void:
	SettingsHelper.sets("epilepsy_mode", flickering_options.selected)
	SettingsHelper.sets("fullscreen_mode", 1 if fullscreen_button.button_pressed else 0)


func _on_exit_button_pressed() -> void:
	save_settings()
	SettingsHelper.apply_settings()
	queue_free()
