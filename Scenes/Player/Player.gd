extends KinematicBody
var gravity = -30
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var cameraMode = "ThirdPerson"
var velocity = Vector3()
var max_speed = 8
var jumpPower = 15
export var health = 12


onready var Camera = $Cameras

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("tab"):
		$Cameras.rotation_degrees = Vector3(-45,0,0)
	if Input.is_action_pressed("rotateright"):
		$Cameras.rotation_degrees.y += 180 * delta
	if Input.is_action_pressed("rotateleft"):
		$Cameras.rotation_degrees.y += -180 * delta
	if Input.is_action_pressed("cam1"):
		$Cameras/FirstPersonCam.current = true
		mouse_range = .2
	if Input.is_action_pressed("cam2"):
		$Cameras/BirdsEyeCam.current = true
		mouse_range = 1.2
	if Input.is_action_pressed("cam3"):
		$Cameras/ThirdPersonCam.current = true
		mouse_range = 1.2

	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Cameras.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Cameras.rotation.x = clamp($Cameras.rotation.x, -mouse_range, mouse_range)
		
func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += jumpPower
	if Input.is_action_pressed("attack") and is_on_floor():
		$AnimationPlayer.play("Attack")
	input_dir = input_dir.normalized()
	return input_dir
	
	
func _physics_process(delta):
	die()
	velocity.y += gravity * delta
	var desired_velocity =  get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	determineAnimation()
	$Weapons/Sword.rotation_degrees = Vector3($Root/Skeleton/WeaponSlot.rotation_degrees.x, $Root/Skeleton/WeaponSlot.rotation_degrees.y + 110 , $Root/Skeleton/WeaponSlot.rotation_degrees.z )
	$Weapons/Sword.global_transform = $Root/Skeleton/WeaponSlot.global_transform
	

func determineAnimation():
	if(is_on_floor() == true and velocity != Vector3.ZERO and $AnimationPlayer.current_animation != "Attack"):
		$AnimationPlayer.play("Walk")
	if(is_on_floor() == true and velocity == Vector3.ZERO and $AnimationPlayer.current_animation != "Attack"):
		$AnimationPlayer.play("Idle")
	if(is_on_floor() == false and velocity.y > 0):
		$AnimationPlayer.play("Jump")
	if(is_on_floor() == false and velocity.y < 0):
		$AnimationPlayer.play("Crouch")


func _on_SwordBox_body_entered(body):
	if($AnimationPlayer.current_animation == "Attack"):
		if(body.has_node("isEnemy")):
			body.health += -1
			print(body.health)
			
func die():
	if(health <= 0):
		get_tree().change_scene("res://Scenes/2D/Loss.tscn")
		Global.score = 0


func _on_Regen_timeout():
	if(health < 10):
		health += 1
