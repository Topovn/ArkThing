extends CharacterBody2D

# -- Config --
@export_group("Movement Settings")
@export var base_speed: float = 300.0
@export var sprint_multiplier: float = 2.0
@export var scale_lerp_speed: float = 10.0

@export_group("Game Progression")
# Dictionary format: { Score_Threshold : Scale_Multiplier }
@export var size_levels: Dictionary = {
	300: 1.5,
	600: 2.0,
	900: 2.5
}

# -- NODES --
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
#@onready var player = $"."
@onready var rock_value: Label = %RockValue

# -- STATE --
var score: int = 0
var base_scale: Vector2 = Vector2.ONE
var target_scale: Vector2 = Vector2.ONE
var processed_levels: Array = []
# -- CURRENT MULT --
var can_move: bool = true
var is_increasing_size: bool = false
var current_size_modifier: float = 1.0

signal size_changed(new_scale_multiplier)

func _ready():
	base_scale = scale
	target_scale = base_scale
	player_sprite.connect("animation_finished", _on_animation_finished)
	#rock_value.text = str(score)

# 2D top down camera
func _physics_process(_delta):
	#player.scale = player.scale.lerp(target_scale, 10 * _delta)
	scale = scale.lerp(target_scale, scale_lerp_speed * _delta)
	
	handle_movement()
	move_and_slide()

func handle_movement():
	if not can_move or is_increasing_size:
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# -- SPEED CALC --
	# Formula : Base * SizeBonus * SprintBonus
	var current_sprint_mult = 1.0
	
	if Input.is_action_pressed("sprint"):
		current_sprint_mult = sprint_multiplier
		player_sprite.speed_scale = 1.2
	else:
		player_sprite.speed_scale = 1.0
	
	
	#velocity = direction * active_speed if direction else velocity.move_toward(Vector2.ZERO, SPEED)
	var final_speed = base_speed * current_size_modifier * current_sprint_mult

	# -- VELOCITY --
	if direction:
		velocity = direction * final_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, final_speed)
	
	
	# -- ANIMATION --
	if direction != Vector2.ZERO:
		player_sprite.flip_h = direction.x < 0
		if player_sprite.animation != "Move":
			player_sprite.play("Move")
	else:
		if player_sprite.animation != "Idle":
			player_sprite.play('Idle')
		

	# debug
	if Input.is_action_just_pressed("add_score"):
		add_score(25)

func add_score(points: int):
	score += points
	#print("Score: ", score)
	rock_value.text = str(score)
	print("Score: ", rock_value.text)
	check_size_upgrade()

func check_size_upgrade():
	for threshold in size_levels.keys():
		if score >= threshold and not threshold in processed_levels:
			var new_scale = size_levels[threshold]
			apply_size_increase(new_scale, threshold)
			return

func apply_size_increase(scale_factor: float, level_threshold: int):
	if is_increasing_size:
		return	
	
	# Lock movement
	can_move = false
	is_increasing_size = true
	velocity = Vector2.ZERO
	
	processed_levels.append(level_threshold)
	
	current_size_modifier = scale_factor
	target_scale = base_scale * scale_factor
	
	player_sprite.play("SizeIncrease")
	size_changed.emit(current_size_modifier)
	
func _on_animation_finished():
	if player_sprite.animation == "SizeIncrease":
		is_increasing_size = false
		can_move = true
		player_sprite.play("Idle")		
