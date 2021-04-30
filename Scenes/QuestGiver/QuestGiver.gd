extends Spatial

var talking = false
var playerInRange = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play("Idle")
	if(playerInRange and Input.is_action_just_pressed("interact")):
		startConvo()

func startConvo():
	if(talking == false):
		var dialog = Dialogic.start("Intro")
		add_child(dialog)
		talking = true
	
	
func _on_SpeechZone_body_entered(body):
	if(body.has_node("isPlayer")):
		playerInRange = true


func _on_SpeechZone_body_exited(body):
	if(body.has_node("isPlayer")):
		playerInRange = false
		talking = false
