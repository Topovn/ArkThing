extends CanvasLayer

# On-screen edge indicators that point toward off-screen rocks.
# Driven by the same "rocks" group used for the score-2000 highlight.

const MARGIN: float = 60.0
const ARROW_COLOR: Color = Color(1, 0.85, 0.1)

var arrows: Dictionary = {} # rock -> Arrow node

class Arrow extends Node2D:
	func _draw():
		var body := PackedVector2Array([Vector2(20, 0), Vector2(-14, -14), Vector2(-14, 14)])
		draw_colored_polygon(body, Color(1, 0.85, 0.1))
		var outline := PackedVector2Array([Vector2(20, 0), Vector2(-14, -14), Vector2(-14, 14), Vector2(20, 0)])
		draw_polyline(outline, Color(0, 0, 0, 1), 2.0)

func _process(_delta):
	var rocks = get_tree().get_nodes_in_group("rocks")

	# Drop arrows whose rock was collected.
	for rock in arrows.keys():
		if not is_instance_valid(rock) or not rock in rocks:
			arrows[rock].queue_free()
			arrows.erase(rock)

	var view_size = get_viewport().get_visible_rect().size
	var canvas_xform = get_viewport().get_canvas_transform()
	var center = view_size / 2.0
	var half = center - Vector2(MARGIN, MARGIN)
	var screen_rect = Rect2(Vector2.ZERO, view_size)

	for rock in rocks:
		var screen_pos = canvas_xform * rock.global_position
		var arrow = arrows.get(rock)

		if screen_rect.has_point(screen_pos):
			if arrow:
				arrow.visible = false
			continue

		if arrow == null:
			arrow = Arrow.new()
			add_child(arrow)
			arrows[rock] = arrow
		arrow.visible = true

		var dir = screen_pos - center
		arrow.rotation = dir.angle()
		# Project the direction onto the inset screen border.
		var t = INF
		if abs(dir.x) > 0.001:
			t = min(t, half.x / abs(dir.x))
		if abs(dir.y) > 0.001:
			t = min(t, half.y / abs(dir.y))
		arrow.position = center + dir * t
