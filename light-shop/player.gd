extends Area2D

@export var SPEED = 400
@export var JUMP_FORCE = 500
@export var GRAVITY = 1200
@export var MARGIN = 150  # Added margin for screen boundaries
@export var CROUCH_SPEED_MULTIPLIER = 0.4  # Reduce speed while crouching

var velocity = Vector2.ZERO
var screen_size
var is_jumping = false
var is_crouch = false

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

	# Apply crouch
	is_crouch = Input.is_action_pressed("crouch")

	# Adjust speed if crouching
	var actual_speed = SPEED
	if is_crouch:
		actual_speed *= CROUCH_SPEED_MULTIPLIER

	# Normalize movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * actual_speed

	# Apply jump
	if Input.is_action_just_pressed("jump") and not is_jumping:
		velocity.y = -JUMP_FORCE
		is_jumping = true

	# Update velocity
	velocity.x = input_vector.x
	position += velocity * delta

	# Ground collision simulation
	if position.y >= screen_size.y - MARGIN:  
		is_jumping = false
		position.y = screen_size.y - MARGIN

	# Clamp to screen
	position.x = clamp(position.x, MARGIN, screen_size.x - MARGIN)
	position.y = clamp(position.y, MARGIN, screen_size.y - MARGIN)

	# Handle animations
	if is_jumping:
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif is_crouch:
		if velocity.x != 0:
			if $AnimatedSprite2D.animation != "crouch_walk":
				$AnimatedSprite2D.play("crouch_walk")
		else:
			if $AnimatedSprite2D.animation != "crouch":
				$AnimatedSprite2D.play("crouch")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.x != 0:
		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
