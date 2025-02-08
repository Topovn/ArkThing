extends Control

# reference vid: https://www.youtube.com/watch?v=vsKxB66_ngw

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/option_menu.tscn")

func _on_exit_pressed():
	get_tree().quit()
