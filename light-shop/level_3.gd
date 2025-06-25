extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelBGM.play()
	$LevelBGM.stream.loop = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_real_bulb_activated():
	# Smoothly fade the darkness or instantly set alpha to 0
	$BlackOverlay.visible = false

	# Disable player spotlight
	$Player/SpotLight.enabled = false
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Ending.tscn")

func _on_idle_timer_timeout() -> void:
	var reaper = $Reaper
	reaper.visible = true
	reaper.is_active = true	
	reaper.target = $Player
	
	$LevelBGM.stop()
	$ReaperChaseBGM.play()
