extends Area2D

@onready var pick_up_sound = $PickUpSound
@onready var animation_player = $AnimationPlayer

@export var points: int = 1 # Default value, can be overridden in the inspector editor

func _on_body_entered(body: Node2D):
	#if body.is_in_group("Player"): 
	body.add_score(points) # Call func on player to add point
	animation_player.play("pickup")
	#print('Nom')
	

