extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MapSize.text = str(settings.map_size)
	# Később megjavítani a felhőket
	# Generált felhők legyenek, több pixelart variáció, random irányba, random mérettel
	$ColorRect/cloud_1.position += Vector2(0.6,0.1)
	$ColorRect/cloud_2.position += Vector2(0.4,-0.1)
	$ColorRect/cloud_3.position += Vector2(0.5,0)
	$ColorRect/cloud_4.position += Vector2(0.4,0)
	$ColorRect/cloud_5.position += Vector2(0.3,0)
#	pass

func _on_StartButton_T_button_down():
	#Nem működik a jelenet váltás miatt
	pass
	


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
	pass # Replace with function body.


func _on_IncreaseButton_mouse_entered():
	$Hover.play()
	pass # Replace with function body.


func _on_ExitButton_T_mouse_entered():
	$Hover.play()
	pass # Replace with function body.


func _on_decreaseButton_mouse_entered():
	$Hover.play()
	pass # Replace with function body.


func _on_IncreaseButton_pressed():
	settings.map_size += 1
	$Pressed.play()
	pass # Replace with function body.


func _on_decreaseButton_pressed():
	settings.map_size -= 1
	$Pressed.play()
	pass # Replace with function body.
