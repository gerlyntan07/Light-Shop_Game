extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_real_bulb_activated():
	# Smoothly fade the darkness or instantly set alpha to 0
	$BlackOverlay.visible = false

	# Disable player spotlight
	$Player/PointLight2D.enabled = false
