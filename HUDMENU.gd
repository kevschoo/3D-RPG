extends Control


var player = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if get_node_or_null("/root/World/Players/Player") != null:
		player = get_node_or_null("/root/World/Players/Player")
		$HUD/ColorRect/Container/Health.text = "Health " + str(player.health)
		$HUD/ColorRect/Container/Level.text = "Level " + str(Global.level)
		$HUD/ColorRect/Container/Score.text  = "Score " + str(Global.score)
		
func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		if $Menu.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$Menu.visible = false
			get_tree().paused = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Menu.visible = true
			show()
			get_tree().paused = true


func _on_Quit_pressed():
	get_tree().quit()
