extends Control


func _play_click():
	$MouseClick.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BGM.play()
	$BGM.stream.loop = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	_play_click()
	$HowToPlayContainer.visible = false


func _on_how_to_play_button_pressed() -> void:
	_play_click()
	$HowToPlayContainer.visible = true


func _on_start_button_pressed() -> void:
	_play_click()
	
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Level1.tscn")


func _on_quit_button_pressed() -> void:
	_play_click()
	get_tree().quit()
