extends CanvasLayer
class_name AcquisitionBox

signal item_taken

@onready var label: Label = $Label
@onready var center_texture: TextureRect = $CenterTexture
@onready var timer: Timer = $Timer
@onready var triangles: Control = $Triangles

func _process(_delta: float) -> void:
	if timer.is_stopped() and Input.is_action_just_pressed("action"):
		hide()
		triangles.process_mode = Node.PROCESS_MODE_DISABLED
		item_taken.emit()

func play_item(item_text: String, item_texture: Texture2D) -> void:
	label.text = item_text
	center_texture.texture = item_texture
	timer.start()
	show()
	triangles.process_mode = Node.PROCESS_MODE_INHERIT
