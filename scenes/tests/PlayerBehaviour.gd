extends KinematicBody2D

var velocity = Vector2()

const SPEED = 150

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
		
	velocity = velocity.normalized() * SPEED
	velocity = move_and_slide(velocity)


func _ready():
	pass
