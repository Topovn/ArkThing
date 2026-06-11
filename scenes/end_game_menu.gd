extends Control

const MUD_RESULT_AUDIO = preload("res://assets/sounds/mudResult.mp3")
const VICTORY_BGM = preload("res://assets/sounds/victory.ogg")

var can_continue: bool = false

func _ready():
	# Music bed (matches the sheep BGM volume from the main game).
	var bgm = AudioStreamPlayer.new()
	bgm.stream = VICTORY_BGM
	bgm.volume_db = -20.0
	add_child(bgm)
	bgm.play()

	var audio = AudioStreamPlayer.new()
	audio.stream = MUD_RESULT_AUDIO
	audio.volume_db = -10.0
	add_child(audio)
	audio.play()
	# The Back button overlaps the clickable area; wire it up so it isn't a dead zone.
	$PanelContainer/Back.pressed.connect(_on_back_pressed)
	# Brief delay so a leftover click from gameplay can't instantly skip the screen.
	await get_tree().create_timer(0.5).timeout
	can_continue = true

func _unhandled_input(event):
	if can_continue and event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") # Replace with function body.
