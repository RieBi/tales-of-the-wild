extends Node
class_name SettingsHelper

static func gets(key: String) -> Variant:
	return settings[key] if key in settings else null

static func sets(key: String, value: Variant) -> void:
	settings[key] = value

static var settings = {
	# 0 - Show flickering images, 1 - DO NOT show flickering images
	"epilepsy_mode": 0
}
