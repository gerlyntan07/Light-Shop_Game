extends CharacterBody2D

@export var SPEED = 300
@export var JUMP_FORCE = 500
@export var GRAVITY = 1200
@export var MARGIN = 150 
@export var CROUCH_SPEED_MULTIPLIER = 0.4

var screen_size
var is_jumping = false
var is_crouch = false
var facing_left := false  # Track last direction
var is_dead = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_normal = $CollisionNormal
@onready var collision_crouch = $CollisionCrouch
@onready var idle_timer = $"../IdleTimer"
var previous_position := Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	#Dead
	if is_dead:
		velocity = Vector2.ZERO
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		is_jumping = false

	# Horizontal input
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1

	# Crouch state
	is_crouch = Input.is_action_pressed("crouch")
	collision_normal.disabled = is_crouch
	collision_crouch.disabled = not is_crouch

	# Movement speed
	var actual_speed = SPEED
	if is_crouch:
		actual_speed *= CROUCH_SPEED_MULTIPLIER

	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * actual_speed

	# Update X velocity
	velocity.x = input_vector.x

	# Track last movement direction for flipping
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouch:
		velocity.y = -JUMP_FORCE
		is_jumping = true

	# Apply movement and update velocity
	move_and_slide()

	# Animations
	if not is_on_floor():
		animated_sprite.play("jump")
	elif is_crouch:
		if velocity.x != 0:
			animated_sprite.play("crouch_walk")
		else:
			animated_sprite.play("crouch")
	elif velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

	# Flip based on last movement
	animated_sprite.flip_h = facing_left
	
	# Detect idleness
	if global_position == previous_position:
		if idle_timer.is_stopped():
			idle_timer.start()
	else:
		idle_timer.stop()
		idle_timer.start()

	previous_position = global_position
