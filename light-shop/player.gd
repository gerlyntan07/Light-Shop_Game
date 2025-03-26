extends Area2D

@export var SPEED = 500
@export var JUMP_FORCE = 600
@export var GRAVITY = 1200
@export var MARGIN = 150  # Added margin for screen boundaries

var velocity = Vector2.ZERO
var screen_size
var is_jumping = false

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	# Apply gravity
	if is_jumping:
		velocity.y += GRAVITY * delta  

	# Handle movement
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1

	# Normalize movement to prevent faster diagonal movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * SPEED

	# Apply jump
	if Input.is_action_just_pressed("jump") and not is_jumping:
		velocity.y = -JUMP_FORCE
		is_jumping = true

	# Update velocity
	velocity.x = input_vector.x
	position += velocity * delta

	# Check if player is at the bottom of the screen (ground simulation)
	if position.y >= screen_size.y - MARGIN:  
		is_jumping = false
		position.y = screen_size.y - MARGIN  # Keep the player above the "ground"

	# Clamp position to stay inside screen with margin
	position.x = clamp(position.x, MARGIN, screen_size.x - MARGIN)
	position.y = clamp(position.y, MARGIN, screen_size.y - MARGIN)

	# Handle animations
	if is_jumping:
		# Jump animation should have the highest priority
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.x != 0:
		# Only play walk if not jumping
		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		# Idle when not jumping or moving
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
