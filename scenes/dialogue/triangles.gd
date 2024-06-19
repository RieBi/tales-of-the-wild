extends Control

func _process(delta: float) -> void:
	if SettingsHelper.gets("epilepsy_mode") == 0:
		rotation += PI / 2 * delta
	else:
		rotation += PI / 20 * delta

func _draw() -> void:
	var show_flick = SettingsHelper.gets("epilepsy_mode") == 0
	var desired_angle = TAU / 10
	draw_triangles(5, desired_angle, 1000, Color.RED if show_flick else Color.WEB_GREEN)
	draw_triangles(5, desired_angle, 1000, Color.BLACK if show_flick else Color.DARK_GREEN, desired_angle)

func draw_triangles(num: int, angle_width: float, length: int, color: Color, offset: float = 0) -> void:
	for i in range(num):
		var start_angle = TAU * i / num + offset
		var points: PackedVector2Array = []
		points.append(Vector2.ZERO)
		points.append(Vector2.from_angle(start_angle) * length)
		points.append(Vector2.from_angle(start_angle + angle_width) * length)
		draw_colored_polygon(points, color)
