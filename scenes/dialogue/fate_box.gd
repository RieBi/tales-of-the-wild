extends CanvasLayer
class_name FateBox

@export var fate_left: Control
@export var fate_right: Control
@export var left_label: Label
@export var right_label: Label
@export var center_texture: TextureRect

signal left_chosen
signal right_chosen
signal fate_chosen

func _process(delta: float) -> void:
	if visible and Input.is_action_pressed("click"):
		if fate_left.visible:
			left_chosen.emit()
		elif fate_right.visible:
			right_chosen.emit()
		else:
			return
		# Any of two
		fate_chosen.emit()
		hide()

func _on_fate_left_area_mouse_entered() -> void:
	fate_left.show()
	fate_right.hide()

func _on_fate_right_area_mouse_entered() -> void:
	fate_right.show()
	fate_left.hide()

func play_fate(left_text: String, right_text: String, texture: Texture2D):
	fate_left.hide()
	fate_right.hide()
	left_label.text = left_text
	right_label.text = right_text
	center_texture.texture = texture
	show()
