extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	$AudioStreamPlayer.play()


func _on_StartButton_T_pressed():
	get_tree().change_scene("res://Scenes & Scripts/PlayGround.tscn")


func _on_ExitButton_T_pressed():
	get_tree().quit()

