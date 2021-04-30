extends KinematicBody

export var health = 4
var target
var space_state
export var speed = 200
var canDamage = true
var inDamageBox = false

func _ready():
	space_state = get_world().direct_space_state

func _on_SearchArea_body_entered(body):
	if body.name == "Player":
		target = body
		print(body.name +"Targeted" )
		$BodyMesh.get_surface_material(0).set_albedo(Color(1,.5,.5))

func _on_SearchArea_body_exited(body):
	if body.name == "Player":
		target = null
		print(body.name +"Lost" )
		$BodyMesh.get_surface_material(0).set_albedo(Color(1,1,1))
		
func _process(delta):
	if(health <= 0):
		die()
	if target != null:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider == target: 
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
			

func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction*speed*delta, Vector3.UP)
		

func die():
	Global.score += 100
	queue_free()


func _on_DamageArea_body_entered(body):
	if(body.has_node("isPlayer")):
		if(canDamage == true):
			body.health += -1
			canDamage = false
			inDamageBox = true

func _on_DamageTimer_timeout():
	canDamage = true
	if(inDamageBox == true and target != null):
		target.health += -1

func _on_DamageArea_body_exited(body):
	inDamageBox = false
