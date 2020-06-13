extends KinematicBody2D

var xSpeed = 0
var ySpeed = 0

var health = 100

enum State {IDLE}
var currentState = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	position += Vector2(xSpeed, ySpeed)
	
	match currentState:
		State.IDLE:
			xSpeed = rand_range(-1, 1)
			ySpeed = rand_range(-1, 1)
