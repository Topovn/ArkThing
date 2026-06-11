extends Camera2D

@onready var player = $"../Player"
@onready var map = $"../Map"
@export var zoomSpeed: float = 10

var SPEED = 10
var zoomTarget: Vector2
var map_rect: Rect2

func _ready():
	zoom *= 0.7
	zoomTarget = zoom
	if map and map.texture:
		var world_size = map.texture.get_size() * map.scale
		map_rect = Rect2(map.global_position - world_size / 2.0, world_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Camera pos will follow player pos
func _process(delta):
	position = lerp(position, player.position,SPEED * delta)
	Zoom(delta)
	_clamp_to_map()

# Keep the visible view inside the map bounds while panning/zooming.
func _clamp_to_map():
	if map_rect.size == Vector2.ZERO:
		return
	var half_view = (get_viewport_rect().size / zoom) / 2.0
	# X axis: clamp if the map is wider than the view, otherwise centre on it.
	if map_rect.size.x >= half_view.x * 2.0:
		position.x = clamp(position.x, map_rect.position.x + half_view.x, map_rect.end.x - half_view.x)
	else:
		position.x = map_rect.position.x + map_rect.size.x / 2.0
	# Y axis.
	if map_rect.size.y >= half_view.y * 2.0:
		position.y = clamp(position.y, map_rect.position.y + half_view.y, map_rect.end.y - half_view.y)
	else:
		position.y = map_rect.position.y + map_rect.size.y / 2.0


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
	
	
