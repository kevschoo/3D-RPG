extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Play_pressed():
	get_tree().change_scene("res://Levels/TestWorld.tscn")

func _on_Button_pressed():
	get_tree().quit()
