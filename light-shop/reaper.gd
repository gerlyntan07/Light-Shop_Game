extends CharacterBody2D

@export var SPEED := 200
var is_active := false
var target: Node2D

func _ready():
	visible = false

func _physics_process(delta):
	if is_active and target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()


func _on_killzone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()
