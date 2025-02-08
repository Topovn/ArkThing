extends AnimatedSprite2D

@onready var mud_sit = $"."


func _ready():
	mud_sit.flip_h = true
