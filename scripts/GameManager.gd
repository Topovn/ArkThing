extends Node

@onready var pause_menu = $"../Camera2D/PauseMenu"

var paused = false

const MISSION_ACCOMPLISHED_AUDIO = preload("res://assets/sounds/missionAccomplished.mp3")
const BABY_DOLL_FONT = preload("res://Baby Doll.ttf")

var rocks_remaining: int = 0
var game_over: bool = false
var rocks_highlighted: bool = false

# Add buffer for Camera2D or replace with PhantomCamera plugin?
# https://www.youtube.com/watch?v=cIFRfqH61bU&list=PLrTq4shPLJgFul2UB0e0tr7swgtwYY4n4&index=5

# Add map border OK
# Maybe only add the border of map as tilemap and make that camera/game border as well?
# https://www.youtube.com/watch?v=ZutpG0_CYrQ

# Add cam stick to world border


# add mudGreeting when start game

func _ready():
	BgmManager.stop_bgm()
	# Rocks add themselves to the "rocks" group in their own _ready, which runs
	# after this node's _ready, so defer the count until the tree is settled.
	call_deferred("_setup_rock_tracking")

func _process(_delta):
	if rocks_highlighted or game_over:
		return
	var player = get_node_or_null("../Player")
	if player and player.score > 2000:
		rocks_highlighted = true
		_highlight_remaining_rocks()

# Debug: press space to jump straight to the endgame sequence.
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		_trigger_endgame()

func _highlight_remaining_rocks():
	for rock in get_tree().get_nodes_in_group("rocks"):
		var sprite = rock.get_node_or_null("Rock")
		if sprite == null:
			continue
		# Bind the tween to the rock so it auto-frees when the rock is collected.
		var pulse = rock.create_tween().set_loops()
		pulse.tween_property(sprite, "modulate", Color(1, 0.85, 0.1), 0.4)
		pulse.tween_property(sprite, "modulate", Color(1, 1, 1), 0.4)

func _setup_rock_tracking():
	var rocks = get_tree().get_nodes_in_group("rocks")
	rocks_remaining = rocks.size()
	for rock in rocks:
		rock.collected.connect(_on_rock_collected)

func _on_rock_collected():
	rocks_remaining -= 1
	if rocks_remaining <= 0:
		_trigger_endgame()

func _trigger_endgame():
	if game_over:
		return
	game_over = true

	# Lock the player and silence the gameplay BGM for the outro.
	var player = get_node_or_null("../Player")
	if player:
		player.can_move = false
	var bgm = get_node_or_null("../BGM")
	if bgm:
		bgm.stop()

	_play_mission_accomplished()

func _play_mission_accomplished():
	var audio = AudioStreamPlayer.new()
	audio.stream = MISSION_ACCOMPLISHED_AUDIO
	audio.volume_db = -20.0
	add_child(audio)
	audio.play()

	var layer = CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	var viewport_size = get_viewport().get_visible_rect().size

	var label = Label.new()
	label.text = "Mission Accomplished"
	label.add_theme_font_override("font", BABY_DOLL_FONT)
	label.add_theme_font_size_override("font_size", 90)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size = Vector2(viewport_size.x, 220)
	label.position = Vector2(-viewport_size.x, (viewport_size.y - 220) / 2.0)
	layer.add_child(label)

	# Slide in from the left to centre, hold, then slide off to the right.
	var tween = create_tween()
	tween.tween_property(label, "position:x", 0.0, 1.0) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.5)
	tween.tween_property(label, "position:x", viewport_size.x, 1.0) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(_go_to_end_screen)

func _go_to_end_screen():
	get_tree().change_scene_to_file("res://scenes/end_game_menu.tscn")
