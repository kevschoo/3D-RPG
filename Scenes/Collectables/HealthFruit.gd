extends Spatial



func _on_Area_body_entered(body):
	if(body.has_node("isPlayer")):
		body.health += 3
		queue_free()
