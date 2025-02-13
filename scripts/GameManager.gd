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
# Add Tile map
# Add buffer for Camera2D or replace with PhantomCamera plugin?


func _ready():
	BgmManager.stop_bgm()
