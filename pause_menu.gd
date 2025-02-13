extends Control
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("RESET")
	hide()

func resume():
	get_tree().paused = false
	animation_player.play_backwards("blur")
	hide()
	
func pause():
	get_tree().paused = true
	animation_player.play("blur")
	show()
	

func testEsc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
		


func _on_resume_pressed():
	resume() 

func _on_quit_pressed():
	#get_tree().quit()
	get_tree().paused = false
	BgmManager.resume_bgm()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func _process(_delta):
	testEsc()
