extends Camera2D

@onready var player = $"../Player"
@export var zoomSpeed: float = 10

var SPEED = 10
var zoomTarget: Vector2

func _ready():
	zoomTarget = zoom
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Camera pos will follow player pos
func _process(delta):
	position = lerp(position, player.position,SPEED * delta)
	Zoom(delta)


func _on_player_size_changed(size_one, size_two):
	if size_one == true and not size_two == true:
		zoomTarget *= 0.8
	elif size_two == true:
		zoomTarget *= 0.8
		
func Zoom(delta): #debug function
	if Input.is_action_just_pressed("zoom_in"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("zoom_out"):
		zoomTarget *= 0.9
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	
	
