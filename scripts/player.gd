extends CharacterBody2D


@onready var player_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var player = $"."
@onready var rock_value = %RockValue


var SPEED: float = 300.0
var score: int = 0 
var base_scale: Vector2 = Vector2.ONE
var target_scale: Vector2 = Vector2.ONE
var current_speed: float = SPEED

var size_increase_one = false
var size_increase_two = false
signal size_changed

var can_move = true
var is_increasing_size = false

func _ready():
	target_scale = base_scale
	player_sprite.connect("animation_finished", _on_AnimatedSprite2D_animation_finished)
	rock_value.text = str(score)

# 2D top down camera
func _physics_process(_delta):
	player.scale = player.scale.lerp(target_scale, 10 * _delta)
	movement()
	move_and_slide()

func movement():
	if not can_move or is_increasing_size:
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * SPEED if direction else velocity.move_toward(Vector2.ZERO, SPEED)
	#if direction:
		#velocity = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.y = move_toward(velocity.y, 0, SPEED) 

	if direction != Vector2.ZERO:
		player_sprite.flip_h = direction.x < 0
		player_sprite.play("Move")
	else:
		player_sprite.play('Idle')

	# debug
	if Input.is_action_just_pressed("add_score"):
		add_score(25)

func add_score(points: int):
	score += points
	#print("Score: ", score)
	rock_value.text = str(score)
	print("Score: ", rock_value.text)
	update_size()

func update_size():
	if score >= 200 and not size_increase_two:
		size_increase_two = true
		start_size_increase(2, 700)
	elif score >= 50 and not size_increase_one:
		size_increase_one = true
		start_size_increase(1.5, 500)

func start_size_increase(scale_factor: float, new_speed: float):
	if is_increasing_size:
		return	
	can_move = false
	is_increasing_size = true
	velocity = Vector2.ZERO
	target_scale = base_scale * scale_factor
	SPEED = new_speed
	player_sprite.play("SizeIncrease")
	emit_signal("size_changed", size_increase_one, size_increase_two)
	

func _on_AnimatedSprite2D_animation_finished():
	if player_sprite.animation == "SizeIncrease":
		is_increasing_size = false
		can_move = true
		player_sprite.play("Idle")
		#collision_shape.shape.size = Vector2(16,16) * target_scale

