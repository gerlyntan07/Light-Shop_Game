extends Area2D

@onready var death_sound = $DeathSound

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		# Stop player movement
		body.is_dead = true
		
		death_sound.play()
		
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
