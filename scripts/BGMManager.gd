extends Node

var menu_bgm = AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_bgm = AudioStreamPlayer2D.new()
	add_child(menu_bgm)
	menu_bgm.stream = preload("res://assets/sounds/mainmenu.mp3")
	menu_bgm.autoplay = true
	menu_bgm.volume_db = -10
	menu_bgm.play()

func stop_bgm():
	menu_bgm.stop()

	
func resume_bgm():
	if not menu_bgm.playing:
		menu_bgm.play()
