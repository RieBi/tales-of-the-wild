extends CanvasLayer
class_name DialogueBox

@export var text_label: RichTextLabel
@export var slow_timer: Timer

const CENTER_KEYWORD := "[center]"
signal action_pressed
signal dialogue_finished
var slow_size = 1

func _process(_delta: float) -> void:
	if visible and Input.is_action_just_pressed("action"):
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

func set_teller_name(teller_name: String) -> void:
	$Panel/NameLabel.text = teller_name

func set_teller_portrait(teller_portrait: CompressedTexture2D) -> void:
	$Panel/CenterContainer/TextureRect.texture = teller_portrait

func _on_slow_text_timer_timeout() -> void:
	text_label.visible_characters += slow_size
	if text_label.visible_ratio == 1:
		slow_timer.stop()
