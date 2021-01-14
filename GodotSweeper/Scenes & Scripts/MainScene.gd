extends Control

func _process(delta):
	$difficulty.text = settings.diffs[settings.difficulty]	
	$DifficultySprite.texture = settings.images[settings.difficulty]
	$MapSize.text = str(settings.map_size)
	var mapsize_text = str(settings.map_size)
	if(int(mapsize_text) > 9):
		$MapSizeHolder/MapNumbers.set_cell(0,0, int(mapsize_text[0]))
		$MapSizeHolder/MapNumbers.set_cell(1,0, int(mapsize_text[1]))
	else:
		$MapSizeHolder/MapNumbers.set_cell(0,0, -1)
		$MapSizeHolder/MapNumbers.set_cell(1,0, int(mapsize_text[0]))


func _on_StartButton_T_pressed():
	$Pressed.play()
	yield($Pressed, "finished")
	get_tree().change_scene("res://Scenes & Scripts/PlayGround.tscn")

func _on_ExitButton_T_pressed():
	$Pressed.play()
	yield($Pressed, "finished")
	get_tree().quit()

func _on_StartButton_T_mouse_entered():
	$Hover.play()

func _on_IncreaseButton_mouse_entered():
	$Hover.play()

func _on_ExitButton_T_mouse_entered():
	$Hover.play()

func _on_decreaseButton_mouse_entered():
	$Hover.play()

func _on_IncreaseButton_pressed():
	if(settings.map_size < 50):
		settings.map_size += 1
	$Pressed.play()

func _on_decreaseButton_pressed():
	if(settings.map_size > 6):
		settings.map_size -= 1
	$Pressed.play()

func _on_Difficulty_up_pressed():
	$Pressed.play()
	settings.difficulty = (settings.difficulty + 1) % 3

func _on_Difficulty_down_pressed():
	settings.difficulty = (settings.difficulty - 1) % 3
	$Pressed.play()

func _on_Difficulty_up_mouse_entered():
	$Hover.play()


func _on_Difficulty_down_mouse_entered():
	$Hover.play()
