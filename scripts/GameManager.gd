extends Node

@onready var pause_menu = $"../Camera2D/PauseMenu"

var paused = false

# TODO
# Add endgame menu + mudResult 
# When collected all rocks -> Babydoll font text Misson Accomplished slides in from the middle left to the middle screen, then to the left while playing MissiopnAccomplished audio
#  then transit to endScreen (end_game_menu.tscn) -> play mudResult.mp3. Lock all input and wait for the user to mouse click anywhere to go back to main menu

# Add buffer for Camera2D or replace with PhantomCamera plugin?
# https://www.youtube.com/watch?v=cIFRfqH61bU&list=PLrTq4shPLJgFul2UB0e0tr7swgtwYY4n4&index=5

# Add map border OK
# Maybe only add the border of map as tilemap and make that camera/game border as well?
# https://www.youtube.com/watch?v=ZutpG0_CYrQ

# Add cam stick to world border


# add mudGreeting when start game

func _ready():
	BgmManager.stop_bgm()
	
