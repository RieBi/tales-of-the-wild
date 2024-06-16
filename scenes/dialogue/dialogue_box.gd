extends CanvasLayer
class_name DialogueBox

@export var text_label: RichTextLabel
@export var slow_timer: Timer

const CENTER_KEYWORD := "[center]"
signal slow_ended
var slow_string = ""
var slow_index = 0
var slow_size = 1

func set_text(text: String):
	text_label.text = CENTER_KEYWORD + text

func set_text_slow(text: String):
	text_label.text = CENTER_KEYWORD
	slow_string = text
	slow_index = 0
	slow_timer.start()

func clear_text() -> void:
	text_label.text = ""
	slow_timer.stop()

func _on_slow_text_timer_timeout() -> void:
	text_label.text += slow_string.substr(slow_index, slow_size)
	slow_index += slow_size
	if slow_index >= slow_string.length():
		slow_timer.stop()
		slow_ended.emit()
