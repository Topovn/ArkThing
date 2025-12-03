extends Node

@onready var pause_menu = $"../Camera2D/PauseMenu"

var paused = false

# TODO
# Change mud sizes depends on point OK
# Add interact anim and call it when change size OK
# Main Menu and Pause Menu OK 
# Add Main Menu with mud sit anim OK
# change screen size + HUD stick to screen size OK
# Add HUD with score point but make HUD sticks in top left OK
# Add BGMs, main menu and gameplay OK
# Add Tile map OK
# Sprint function OK

# Add buffer for Camera2D or replace with PhantomCamera plugin?
# https://www.youtube.com/watch?v=cIFRfqH61bU&list=PLrTq4shPLJgFul2UB0e0tr7swgtwYY4n4&index=5

# Add map border OK
# Maybe only add the border of map as tilemap and make that camera/game border as well?
# https://www.youtube.com/watch?v=ZutpG0_CYrQ

# Add cam stick to world border

func _ready():
	BgmManager.stop_bgm()
	
