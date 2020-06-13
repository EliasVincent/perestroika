extends KinematicBody2D

onready var playerNode = get_node("/root/Main/Player")

var xSpeed = 0
var ySpeed = 0

var health = 100

enum State {IDLE, ATTACK}
var currentState = State.ATTACK

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	position += Vector2(xSpeed, ySpeed)
	
	if Input.is_action_just_pressed("idleState"):
		currentState = State.IDLE
	if (Input.is_action_just_pressed("attackState")):
		currentState = State.ATTACK
	
	match currentState:
		State.IDLE:
			xSpeed = rand_range(-1, 1)
			ySpeed = rand_range(-1, 1)
		State.ATTACK:	
			xSpeed = 0
			ySpeed = 0		
			position = position.move_toward(playerNode.position, delta * 100)
