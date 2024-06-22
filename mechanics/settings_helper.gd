extends Node
class_name SettingsHelper

static func gets(key: String) -> Variant:
	return settings[key] if key in settings else null

static func sets(key: String, value: Variant) -> void:
	settings[key] = value

static func apply_settings() -> void:
	var fullscreen_mode = SettingsHelper.gets("fullscreen_mode")
	var full_mode = DisplayServer.WINDOW_MODE_MAXIMIZED if fullscreen_mode == 0 else DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(full_mode)

static var settings = {
	# 0 - Show flickering images, 1 - DO NOT show flickering images
	"epilepsy_mode": 0,
	
	# 0 - windowed, 1 - fullscreen
	"fullscreen_mode": 0,
}
