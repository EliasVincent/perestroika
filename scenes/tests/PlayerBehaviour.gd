extends KinematicBody2D

var velocity = Vector2(0,0)

const SPEED = 200

# everything physics and controls should happen in _physics_process
func _physics_process(delta):
	
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("down"):
		velocity.y = SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		
	# moves the body, with the velocity as parameter
	velocity = move_and_slide(velocity)

	# function that slowly stops the player, adjust the last value of the speed of the slowdown
	velocity.x = lerp(velocity.x,0,0.2)
	velocity.y = lerp(velocity.y,0,0.2)
	

func _ready():
	pass
