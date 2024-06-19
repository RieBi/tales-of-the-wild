extends Node2D

signal puzzle_solved

@onready var indicators: Array[Node] = $Indicators.get_children()
@onready var toggles: Array[Node] = $Toggles.get_children()
var indicator_state: Array[int] = [0, 0, 0, 0, 0, 0]
var toggle_state: Array[int] = [0, 0, 0, 0, 0, 0]

func _ready() -> void:
	set_indicator_sprites()

func set_indicator_sprites() -> void:
	for i in range(indicator_state.size()):
		var indicator: Sprite2D = indicators[i]
		if indicator_state[i] % 2 == 0:
			indicator.texture = preload("res://assets/sprites/level1/temple_indicator2.png")
		else:
			indicator.texture = preload("res://assets/sprites/level1/temple_indicator1.png")

func activate_toggle(index: int) -> void:
	toggle_state[index] += 1
	var toggle: Sprite2D = toggles[index]
	if toggle_state[index] % 2 == 0:
		toggle.texture = preload("res://assets/sprites/level1/temple_toggle1.png")
	else:
		toggle.texture = preload("res://assets/sprites/level1/temple_toggle2.png")
	
	match index:
		0:
			indicator_state[0] += 1
			indicator_state[3] += 1
			indicator_state[5] += 1
		1:
			indicator_state[1] += 1
			indicator_state[3] += 1
			indicator_state[4] += 1
		2:
			indicator_state[1] += 1
			indicator_state[2] += 1
			indicator_state[3] += 1
		3:
			indicator_state[1] += 1
			indicator_state[2] += 1
		4:
			indicator_state[0] += 1
			indicator_state[4] += 1
			indicator_state[5] += 1
		5:
			indicator_state[0] += 1
			indicator_state[5] += 1
	set_indicator_sprites()
	if indicator_state.all(func(f): return f % 2 == 1):
		complete_puzzle()

func complete_puzzle() -> void:
	puzzle_solved.emit()
	remove_child($TogglesTriggers)

func _on_toggle_trigger_1_action_done(_source: ActionTrigger) -> void:
	activate_toggle(0)

func _on_toggle_trigger_2_action_done(_source: ActionTrigger) -> void:
	activate_toggle(1)

func _on_toggle_trigger_3_action_done(_source: ActionTrigger) -> void:
	activate_toggle(2)

func _on_toggle_trigger_4_action_done(_source: ActionTrigger) -> void:
	activate_toggle(3)

func _on_toggle_trigger_5_action_done(_source: ActionTrigger) -> void:
	activate_toggle(4)

func _on_toggle_trigger_6_action_done(_source: ActionTrigger) -> void:
	activate_toggle(5)
