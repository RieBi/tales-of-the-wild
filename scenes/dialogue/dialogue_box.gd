extends CanvasLayer
class_name DialogueBox

@export var text_label: RichTextLabel
@export var slow_timer: Timer

const CENTER_KEYWORD := "[center]"
signal action_pressed
var slow_size = 1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		action_pressed.emit()

func set_text(text: String):
	text_label.text = CENTER_KEYWORD + text

func set_text_slow(text: String):
	set_text(text)
	text_label.visible_characters = 0
	slow_timer.start()

func clear_text() -> void:
	text_label.text = ""
	slow_timer.stop()

func show_all_text() -> void:
	slow_timer.stop()
	text_label.visible_ratio = 1

func _on_slow_text_timer_timeout() -> void:
	text_label.visible_characters += slow_size
	if text_label.visible_characters >= text_label.text.length():
		slow_timer.stop()
