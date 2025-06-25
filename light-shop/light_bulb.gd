# light_bulb.gd
extends Area2D

@export var is_real_bulb := false           # Set true for the correct bulb
@export var bulb_texture_on: Texture2D

var player_in_range := false
@onready var sprite = $Sprite2D
@onready var bulb_on_audio = $realBulb
@onready var wrong_bulb = $fakeBulb

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body: Node):
	if body.name == "Player":
		player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		_check_bulb()

func _check_bulb():
	if is_real_bulb:				
		bulb_on_audio.play()
		sprite.texture = bulb_texture_on
				
		var level = get_tree().get_current_scene()
		if level.has_method("on_real_bulb_activated"):
			level.on_real_bulb_activated()
				
	else:
		wrong_bulb.play()
  
