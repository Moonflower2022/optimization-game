extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -850.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var double_jump = false
var jump = false

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		double_jump = false
		jump = false
	else:
		velocity.y += gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump = true
		elif not double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x/2, 0, 12)
		
	if Input.is_action_just_pressed("fall") and is_on_floor():
		position.y += 1
		

	move_and_slide()
	
	var is_left = velocity.x < 0
	var is_right = velocity.x > 0
	
	if is_left:
		sprite_2d.flip_h = true
	elif is_right:
		sprite_2d.flip_h = false
		
	if double_jump:
		sprite_2d.animation = "double jump"
	elif jump: 
		sprite_2d.animation = "jumping"
	elif velocity.x != 0:
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
